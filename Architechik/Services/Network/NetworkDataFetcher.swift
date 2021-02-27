//
//  NetworkDataFetcher.swift
//  Architechik
//
//  Created by Александр Цветков on 27.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class NetworkDataFetcher {
    
    fileprivate init() {}
    static let shared = NetworkDataFetcher()
    var studentProgress: Array<StudentProgress> = []
//    {
//        var array: Array<StudentProgress> = []
//        _ = DataManager.shared.fetchAllStudentProgress().map({ progressCD in
//            array.append(StudentProgress(fromModel: progressCD))
//        })
//        return array
//    }()
    var courses: Array<Course> = []
    var timesCreateUserCalled: Int = 0
    var timesGetProgressCalled: Int = 0
    var idCoursesToPurchase: Array<String> = []
    
    func fetchCourses(completion: @escaping (Array<Course>) -> Void ) {
        NetworkService.shared.getCourses { result in
            switch result {
            case .success(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    let index = dataString.index(dataString.startIndex, offsetBy: 1)
                    if dataString.contains("<b>Warning</b>") || dataString.contains("[]") || dataString == "0" || dataString[index] == "0" {
                        completion([])
                        return
                    }
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let models = try decoder.decode(Array<Course>.self, from: data)
                    self.courses = models
                    completion(models)
                    //print(models)
                } catch {
                    print("Failed to decode courses: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("Failed to get courses: \(error)")
                completion([])
            } // switch
        } // get courses
    } // fetchCourses
    
    func fetchArticles(completion: @escaping (Array<Article>) -> Void ) {
        NetworkService.shared.getArticles { result in
            switch result {
            case .success(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    let index = dataString.index(dataString.startIndex, offsetBy: 1)
                    if dataString.contains("<b>Warning</b>") || dataString.contains("[]") || dataString == "0" || dataString[index] == "0" {
                        completion([])
                        return
                    }
                    
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let models = try decoder.decode(Array<Article>.self, from: data)
                    completion(models)
                    //print(models)
                } catch {
                    print("Failed to decode articles: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("Failed to get articles: \(error)")
                completion([])
            }
        }
    }
    
    func fetchGrammar(completion: @escaping (Array<Grammar>) -> Void ) {
        NetworkService.shared.getGrammar { result in
            switch result {
            case .success(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    let index = dataString.index(dataString.startIndex, offsetBy: 1)
                    if dataString.contains("<b>Warning</b>") || dataString.contains("[]") || dataString == "0" || dataString[index] == "0" {
                        completion([])
                        return
                    }
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let models = try decoder.decode(Array<Grammar>.self, from: data)
                    completion(models)
                    //print(models)
                } catch {
                    print("Failed to decode grammar: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("Failed to get grammar: \(error)")
                completion([])
            }
        }
    }
    
    func fetchAchievments(completion: @escaping (Array<Achievement>) -> Void ) {
        NetworkService.shared.getAchievements { result in
            switch result {
            case .success(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    let index = dataString.index(dataString.startIndex, offsetBy: 1)
                    if dataString.contains("<b>Warning</b>") || dataString.contains("[]") || dataString == "0" || dataString[index] == "0" {
                        completion([])
                        return
                    }
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let models = try decoder.decode(Array<Achievement>.self, from: data)
                    completion(models)
                    //print(models)
                } catch {
                    print("Failed to decode achievements: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("Failed to get achievements: \(error)")
                completion([])
            }
        }
    }
    
    func fetchCourseStructure(completion: @escaping (Array<Lesson>) -> Void ) {
            NetworkService.shared.getCourseStructure { result in
                switch result {
                case .success(let data):
                    if let dataString = String(data: data, encoding: .utf8) {
                        let index = dataString.index(dataString.startIndex, offsetBy: 1)
                        if dataString.contains("<b>Warning</b>") || dataString.contains("[]") || dataString == "0" || dataString[index] == "0" {
                            completion([])
                            return
                        }
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let models = try decoder.decode(Array<Lesson>.self, from: data)
                        completion(models)
                        //print(models)
                    } catch {
                        print("Failed to decode course structure: \(error)")
                        completion([])
                    }
                case .failure(let error):
                    print("Failed to get course structure: \(error)")
                    completion([])
                }
        }
    }
    
    //MARK: - Handle user credentials
    private func fetchStudentProgress(completion: @escaping (Array<StudentProgress>?) -> Void ) {
        NetworkService.shared.getUserInfo { result in
            switch result {
            case .success(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    if dataString.contains("0") && dataString.count < 5 {
                        completion([])
                        return
                    }
                    if dataString.contains("<b>Warning</b>") || dataString.contains("[]") {
                        completion(nil)
                        self.timesGetProgressCalled += 1
                        if self.timesGetProgressCalled == 4 {
                            self.timesGetProgressCalled = 0
                            NotificationCenter.default.post(name: NSNotification.Name("ShowServerAlert"), object: nil, userInfo: ["title": "Ошибка", "text": "Не удалось получить ваши данные"])
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.fetchStudentProgress(completion: completion)
                            }
                        }
                        return
                    }
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let models = try decoder.decode(Array<StudentProgress>.self, from: data)
                    completion(models)
                    self.timesGetProgressCalled = 0
                } catch {
                    print("Failed to decode student progress: \(error)")
                    self.timesGetProgressCalled += 1
                    if self.timesGetProgressCalled == 4 {
                        self.timesGetProgressCalled = 0
                        NotificationCenter.default.post(name: NSNotification.Name("ShowServerAlert"), object: nil, userInfo: ["title": "Ошибка", "text": "Не удалось получить ваши данные"])
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.fetchStudentProgress(completion: completion)
                        }
                    }
                    completion(nil)
                }
            case .failure(let error):
                print("Failed to get student progress: \(error)")
                self.timesGetProgressCalled += 1
                if self.timesGetProgressCalled == 4 {
                    self.timesGetProgressCalled = 0
                    NotificationCenter.default.post(name: NSNotification.Name("ShowServerAlert"), object: nil, userInfo: ["title": "Ошибка", "text": "Не удалось получить ваши данные"])
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchStudentProgress(completion: completion)
                    }
                }
                completion(nil)
            }
        }
    }
    
    func checkUserInDatabase(completion: @escaping (Array<StudentProgress>) -> Void ) {
        NetworkDataFetcher.shared.fetchStudentProgress { studentProgress in
            guard let progress = studentProgress else {
                //NotificationCenter.default.post(name: NSNotification.Name("CreateMonitor"), object: nil)
                completion([])
                return
            }
            //print(progress)
            if progress.isEmpty {
                self.createUserWithToken { result in }
                completion([])
            } else {
                
                //let correctProgress = self.compareAndGetCorrectPurchaseStatus(newModels: progress)
                let correctProgress = progress
                DataManager.shared.saveStudentProgress(correctProgress)
                self.studentProgress = correctProgress.sorted(by: { $0.idCourses < $1.idCourses } )
                NotificationCenter.default.post(name: NSNotification.Name("SetProgress"), object: nil)
                completion([])
            }
            //NotificationCenter.default.post(name: NSNotification.Name("CreateMonitor"), object: nil)
        }
    }
    
    private func createUserWithToken(completion: @escaping (Result<String, Error>) -> Void ) {
        NetworkService.shared.createUser { result in
            switch result {
            case .success(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    if dataString.contains("<b>Warning</b>") || dataString.contains("[]") || dataString.contains("0") {
                        completion(.failure(NetworkError.userNotCreated))
                        self.timesCreateUserCalled += 1
                        if self.timesCreateUserCalled == 4 {
                            self.timesCreateUserCalled = 0
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.createUserWithToken(completion: completion)
                            }
                        }
                        return
                    }
                }
                completion(.success("User created"))
                self.timesCreateUserCalled = 0
                self.checkUserInDatabase { _ in }
            case .failure(let error):
                completion(.failure(error))
                print("Wrong response when create user: \(error)")
                self.timesCreateUserCalled += 1
                if self.timesCreateUserCalled == 4 {
                    self.timesCreateUserCalled = 0
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.createUserWithToken(completion: completion)
                    }
                }
            } // switch
        } // Create user
    }
    
    private func compareAndGetCorrectPurchaseStatus(newModels: Array<StudentProgress>) -> Array<StudentProgress> {
        let oldProgressCD = DataManager.shared.fetchAllStudentProgress()
        guard !oldProgressCD.isEmpty else { return newModels }
        var oldProgress: Array<StudentProgress> = []
        var correctProgress: Array<StudentProgress> = []
        var coursesToRetry: Array<String> = []
        _ = oldProgressCD.map({ progressCD in
            let progress = StudentProgress(fromModel: progressCD)
            oldProgress.append(progress)
        })
        for i in 0...oldProgress.count - 1 {
            _ = newModels.map({ new in
                if oldProgress[i].idCourses == new.idCourses {
                    var correct = oldProgress[i]
                    if oldProgress[i].currentProgress.filter({ "1".contains($0) }).count < new.currentProgress.filter({ "1".contains($0) }).count {
                        correct.currentProgress = new.currentProgress
                    }
                    if oldProgress[i].courseAccess != new.courseAccess {
                        coursesToRetry.append(new.idCourses)
                        correct.courseAccess = "1"
                    }
                    correctProgress.append(correct)
                }
            })
        }
        idCoursesToPurchase = coursesToRetry
        print(idCoursesToPurchase)
        retryPurchases()
        return correctProgress
    }
    
    private func retryPurchases() {
        guard !idCoursesToPurchase.isEmpty else { return }
        tryToPurchaseAgain(timesCalled: 0, courseIdIndex: 0)
    }
    
    private func tryToPurchaseAgain(timesCalled: Int, courseIdIndex: Int) {
        NetworkService.shared.buyCourse(courseId: idCoursesToPurchase[courseIdIndex]) { result in
            switch result {
            case .success(let data):
                guard let dataString = String(data: data, encoding: .utf8) else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if timesCalled == 3 && (self.idCoursesToPurchase.count >= courseIdIndex + 2) {
                            self.tryToPurchaseAgain(timesCalled: 0, courseIdIndex: courseIdIndex + 1)
                        } else if timesCalled == 3 {
                            self.idCoursesToPurchase = []
                        } else if timesCalled != 3 {
                            self.tryToPurchaseAgain(timesCalled: timesCalled + 1, courseIdIndex: courseIdIndex)
                        }
                    }
                    return
                }
                
                if dataString.contains("0") || !dataString.contains("1") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if timesCalled == 3 && (self.idCoursesToPurchase.count >= courseIdIndex + 2) {
                            self.tryToPurchaseAgain(timesCalled: 0, courseIdIndex: courseIdIndex + 1)
                        } else if timesCalled == 3 {
                            self.idCoursesToPurchase = []
                        } else if timesCalled != 3 {
                            self.tryToPurchaseAgain(timesCalled: timesCalled + 1, courseIdIndex: courseIdIndex)
                        }
                    }
                    return
                }
                if self.idCoursesToPurchase.count >= courseIdIndex + 2 {
                    self.tryToPurchaseAgain(timesCalled: 0, courseIdIndex: courseIdIndex + 1)
                } else {
                    self.idCoursesToPurchase = []
                }
            case .failure(let error):
                print("Error with purchasing: \(error)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if timesCalled == 3 && (self.idCoursesToPurchase.count >= courseIdIndex + 2) {
                        self.tryToPurchaseAgain(timesCalled: 0, courseIdIndex: courseIdIndex + 1)
                    } else if timesCalled == 3 {
                        self.idCoursesToPurchase = []
                    } else if timesCalled != 3 {
                        self.tryToPurchaseAgain(timesCalled: timesCalled + 1, courseIdIndex: courseIdIndex)
                    }
                }
            }
        }
    }
}
