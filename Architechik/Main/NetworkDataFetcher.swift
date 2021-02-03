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
    
    func fetchCourses(completion: @escaping (Array<Course>) -> Void ) {
        NetworkService.shared.getCourses { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let models = try decoder.decode(Array<Course>.self, from: data)
                    completion(models)
                    //print(models)
                } catch {
                    print("Failed to decode courses: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("Failed to get courses: \(error)")
                completion([])
            }
        }
    }
    
    func fetchArticles(completion: @escaping (Array<Article>) -> Void ) {
        NetworkService.shared.getArticles { result in
            switch result {
            case .success(let data):
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
    
    func fetchStudentProgress(completion: @escaping (Array<StudentProgress>) -> Void ) {
        NetworkService.shared.getUserInfo(courseId: "1") { result in
            switch result {
            case .success(let data):
                let dataString = String(data: data, encoding: .utf8)
                print(dataString ?? "Failed to convert original data to string")
                completion([])
            case .failure(let error):
                print("Failed to get student progress: \(error)")
                completion([])
            }
        }
    }
}
