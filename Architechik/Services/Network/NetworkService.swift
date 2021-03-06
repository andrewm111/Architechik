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
    
    func getCourseStructure(completion: @escaping SessionResult) {
        makeGetRequest(ofType: .getCourseStructure, queryPart: "", completion: completion)
    }
    
    //MARK: - POST requests
    func createUser(completion: @escaping SessionResult) {
        makePostRequest(ofType: .post("create"), courseId: nil, values: nil, completion: completion)
    }
    
    func getUserInfo(completion: @escaping SessionResult) {
        makePostRequest(ofType: .post("get"), courseId: nil, values: nil, completion: completion)
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
        var request = URLRequest(url: url)
        //var request = URLRequest(url: url, timeoutInterval: 3)
        request.httpMethod = type.getHTTPMethod()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleSession(ofType: type, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func makePostRequest(ofType type: RequestType, courseId: String?, values: String?, completion: @escaping SessionResult) {
        let urlString = API.scheme + "://" + API.host + type.getPath()
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.failedToCreateURL))
            return
        }
        var request = URLRequest(url: url)
        //var request = URLRequest(url: url, timeoutInterval: Double.infinity)
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
            //print("Status code: \(response.statusCode)")
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
//            let dataString = String(data: data, encoding: .utf8)
//            print(dataString ?? "Failed to convert original data to string")
            self.cutUnnecessaryData(data, completion: completion)
        }
    }
    
    private func generateHttpBody(type: RequestType, courseId: String?, values: String?) -> Data? {
        let defaults = UserDefaults.standard
        var string = "password=abc_132-A-b"
        switch type {
        case .post(let type):
            string += "&type=\(type)"
            if type == "create" {
                if let email = defaults.string(forKey: "email") { string += "&email=\(email)" }
                if let name = defaults.string(forKey: "fullName") { string += "&name=\(name)" }
            }
        default:
            return nil
        }
        if let token = defaults.string(forKey: "userIdentifier") {
            string += "&token=\(token)"
        } else if KeychainItem.currentUserIdentifier != "" {
            string += "&token=\(KeychainItem.currentUserIdentifier)"
        }
        
        if let id = courseId {
            string += "&course_id=\(id)"
        }
        if let values = values {
            string += "&value=\(values)"
        }
        //print(string)
        let data = string.data(using: .utf8)
        return data
    }
    
    private func cutUnnecessaryData(_ data: Data, completion: @escaping SessionResult) {
        guard let dataString = String(data: data, encoding: .utf8) else {
            completion(.failure(NetworkError.dataIsNotConvertibleToString))
            return
        }
        //print(dataString)
        guard
            let startIndex = dataString.endIndex(of: "<body>"),
            let endIndex = dataString.index(of: "</body>")
            else {
                completion(.failure(NetworkError.dataIsNotJSON))
                return
        }
        var newString = dataString[startIndex..<endIndex]
        if let arrayStartIndex = newString.firstIndex(of: "["), let arrayEndIndex = newString.firstIndex(of: "]") {
            newString = newString[arrayStartIndex...arrayEndIndex]
        }
        //print(newString)
        if let newData = newString.data(using: .utf8) {
            completion(.success(newData))
        } else {
            completion(.failure(NetworkError.failedToConvertBackToData))
        }
    }
}
