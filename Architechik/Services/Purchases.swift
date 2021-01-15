//
//  Purchases.swift
//  Architechik
//
//  Created by Александр Цветков on 15.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import StoreKit

typealias RequestProductsResult = Result<[SKProduct], Error>
typealias PurchaseProductResult = Result<Bool, Error>

typealias RequestProductsCompletion = (RequestProductsResult) -> Void
typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void

class Purchases: NSObject {
    static let `default` = Purchases()
    
    private let productIdentifiers = Set<String>(
        arrayLiteral: "FirstInArchitectureCourseTest"
    )
    
    private var products: [String: SKProduct]?
    private var productRequest: SKProductsRequest?
    
    func initialize(completion: @escaping RequestProductsCompletion) {
        requestProducts(completion: completion)
    }
    
    private var productsRequestCallbacks = [RequestProductsCompletion]()
    
    private func requestProducts(completion: @escaping RequestProductsCompletion) {
        print(#function)
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }
        
        productsRequestCallbacks.append(completion)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
        
        self.productRequest = productRequest
    }
    
    fileprivate var productPurchaseCallback: ((PurchaseProductResult) -> Void)?
    
    func purchaseProduct(productId: String, completion: @escaping (PurchaseProductResult) -> Void) {
        print(#function)
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        
        guard let product = products?[productId] else {
            completion(.failure(PurchasesError.productNotFound))
            return
        }
        
        productPurchaseCallback = completion
        
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restorePurchases(completion: @escaping (PurchaseProductResult) -> Void) {
        print(#function)
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        productPurchaseCallback = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

//MARK: - SKProductsRequestDelegate
extension Purchases: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(#function)
        guard !response.products.isEmpty else {
            print("Found 0 products")
            
            productsRequestCallbacks.forEach { $0(.success(response.products)) }
            productsRequestCallbacks.removeAll()
            return
        }
        
        var products = [String: SKProduct]()
        for skProduct in response.products {
            print("Found product: \(skProduct.productIdentifier)")
            products[skProduct.productIdentifier] = skProduct
        }
        
        self.products = products
        
        productsRequestCallbacks.forEach { $0(.success(response.products)) }
        productsRequestCallbacks.removeAll()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products with error:\n \(error)")
        
        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
    
    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        print("Product \(productId) successfully purchased")
        return true
    }
}

//MARK: - SKPaymentTransactionObserver
extension Purchases: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(#function)
        for transaction in transactions {
            switch transaction.transactionState {
                
            case .purchased, .restored:
                if finishTransaction(transaction) {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    productPurchaseCallback?(.success(true))
                } else {
                    productPurchaseCallback?(.failure(PurchasesError.unknown))
                }
                
            case .failed:
                print("Transaction error: \(String(describing: transaction.error))")
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print("Transaction state: \(transaction.transactionState)")
            }
        }
        
        productPurchaseCallback = nil
    }
}

//MARK: - SKProduct extension
extension SKProduct {
    
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
    
    var title: String? {
        switch productIdentifier {
        case "FirstInArchitectureCourse":
            return "Полный доступ к курсу \"First In Architecture\""
        default:
            return nil
        }
    }
}
