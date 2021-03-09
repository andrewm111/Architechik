//
//  NetworkError.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case serverError(Error)
    case dataIsNil
    case responseIsNil
    case wrongStatusCode
    case dataIsNotConvertibleToString
    case dataIsNotJSON
    case failedToConvertBackToData
    case failedToCreateURL
    case userNotCreated
}
