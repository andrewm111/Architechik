//
//  NetworkService.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

class NetworkService {
    
    typealias SessionResult = (Result<Data, Error>) -> Void
    static let shared = NetworkService()
    fileprivate init() {}
    
    //MARK: - GET requests
    func getCourses(completion: @escaping SessionResult) {
        makeGetRequest(ofType: .getTable("courses"), queryPart: "", completion: completion)
    }
    
    func getArticles(completion: @escaping SessionResult) {
        makeGetRequest(ofType: .getTable("articles"), queryPart: "", completion: completion)
    }
    
    func getGrammar(completion: @escaping SessionResult) {
        makeGetRequest(ofType: .getTable("grammar"), queryPart: "", completion: completion)
    }
    
    func getAchievements(completion: @escaping SessionResult) {
        makeGetRequest(ofType: .getTable("achievements"), queryPart: "", completion: completion)
    }
    
    func getCourseStructure(id: String, completion: @escaping SessionResult) {
        makeGetRequest(ofType: .getCourseStructure(id), queryPart: "&course_id=\(id)", completion: completion)
    }
    
    //MARK: - POST requests
    func createUser(courseId: String, completion: @escaping SessionResult) {
        makePostRequest(ofType: .post("create"), courseId: courseId, values: nil, completion: completion)
    }
    
    func getUserInfo(courseId: String, completion: @escaping SessionResult) {
        makePostRequest(ofType: .post("get"), courseId: courseId, values: nil, completion: completion)
    }
    
    func updateInfo(courseId: String, values: String, completion: @escaping SessionResult) {
        makePostRequest(ofType: .post("update"), courseId: courseId, values: values, completion: completion)
    }
    
    func buyCourse(courseId: String, completion: @escaping SessionResult) {
        makePostRequest(ofType: .post("buy"), courseId: courseId, values: nil, completion: completion)
    }
    
    //MARK: - Request methods
    private func makeGetRequest(ofType type: RequestType, queryPart: String, completion: @escaping SessionResult) {
        let urlString = API.scheme + "://" + API.host + type.getPath() + queryPart
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.failedToCreateURL))
            return
        }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = type.getHTTPMethod()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleSession(ofType: type, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func makePostRequest(ofType type: RequestType, courseId: String?, values: String?, completion: @escaping SessionResult) {
        let urlString = API.scheme + "://" + API.host + type.getPath()
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.failedToCreateURL))
            return
        }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = type.getHTTPMethod()
        request.httpBody = generateHttpBody(type: type, courseId: courseId, values: values)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleSession(ofType: type, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    //MARK: - Supporting methods
    private func handleSession(ofType type: RequestType, data: Data?, response: URLResponse?, error: Error?, completion: @escaping SessionResult) {
        DispatchQueue.main.async {
            if let error = error {
                print("\(error.localizedDescription) in \(#function) of type \(type)")
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Error with unwrapping response in \(#function) of type \(type)")
                completion(.failure(NetworkError.responseIsNil))
                return
            }
            print("Status code: \(response.statusCode)")
            guard (200...299).contains(response.statusCode) else {
                print("Status code is wrong: \(response.statusCode) in \(#function) of type \(type)")
                completion(.failure(NetworkError.wrongStatusCode))
                return
            }
            guard let data = data else {
                print("Failed to unwrap data in \(#function) of type \(type)")
                completion(.failure(NetworkError.dataIsNil))
                return
            }
            let dataString = String(data: data, encoding: .utf8)
            print(dataString ?? "Failed to convert original data to string")
            if type == .getTable("") || type == .getCourseStructure("") {
                self.cutUnnecessaryData(data, completion: completion)
            } else {
                completion(.success(data))
            }
        }
    }
    
    private func generateHttpBody(type: RequestType, courseId: String?, values: String?) -> Data? {
        //let token = UserDefaults.standard.string(forKey: "userIdentifier") ?? "123"
        let token = "321"
        var typeString = ""
        switch type {
        case .post(let type):
            typeString = type
        default:
            break
        }
        var parametersArray: Array<(String, String, Bool)> = [
            ("password", "abc_132-A-b", false),
            ("token", token, false),
            ("type", typeString, false)
        ]
        if let id = courseId {
            parametersArray.append(("course_id", id, false))
        }
        if let values = values {
            parametersArray.append(("values", values, false))
        }
        var parameters = ""
        parameters.makeFields(rows: parametersArray)
        print(parameters)
        return parameters.data(using: .utf8)
    }
    
    private func cutUnnecessaryData(_ data: Data, completion: @escaping SessionResult) {
        guard let dataString = String(data: data, encoding: .utf8) else {
            completion(.failure(NetworkError.dataIsNotConvertibleToString))
            return
        }
        guard let start = dataString.firstIndex(of: "["),
            let end = dataString.lastIndex(of: "]")
            else {
                completion(.failure(NetworkError.dataIsNotJSON))
                return
        }
        let string = dataString[start...end]
        if let newData = string.data(using: .utf8) {
            completion(.success(newData))
        } else {
            completion(.failure(NetworkError.failedToConvertBackToData))
        }
    }
}
