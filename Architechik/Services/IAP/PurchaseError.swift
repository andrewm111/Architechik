//
//  PurchaseError.swift
//  Architechik
//
//  Created by Александр Цветков on 15.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

enum PurchasesError: Error {
    case purchaseInProgress
    case productNotFound
    case unknown
}
