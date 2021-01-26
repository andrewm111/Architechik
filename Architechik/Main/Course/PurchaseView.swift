//
//  PurchaseView.swift
//  Architechik
//
//  Created by Александр Цветков on 26.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class PurchaseView: UIView {

    //MARK: - Subviews
    lazy var purchaseButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 20
        let font = UIFont(name: "Arial-BoldMT", size: 18) ?? UIFont.systemFont(ofSize: 18)
        let attributedString = NSAttributedString(string: "", attributes: attributes)
        view.backgroundColor = UIColor(hex: "613191")
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var restoreButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 20
        let font = UIFont(name: "Arial-BoldMT", size: 18) ?? UIFont.systemFont(ofSize: 18)
        let attributedString = NSAttributedString(string: "Restore purchase", attributes: attributes)
        view.backgroundColor = UIColor(hex: "613191")
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
    
    //MARK: - Properties
    private var delegate: PurchaseDelegate?
    
    convenience init(withDelegate delegate: PurchaseDelegate) {
        self.init(frame: .zero)
        self.delegate = delegate
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        backgroundColor = UIColor(hex: "1F1F24")
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 20
        clipsToBounds = true
        purchaseButton.addTarget(self, action: #selector(purchasePressed), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restorePressed), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        addSubview(purchaseButton)
        addSubview(restoreButton)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            purchaseButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            purchaseButton.bottomAnchor.constraint(equalTo: restoreButton.topAnchor, constant: -15),
            purchaseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            purchaseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            restoreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            restoreButton.heightAnchor.constraint(equalTo: purchaseButton.heightAnchor, multiplier: 0.5),
            restoreButton.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor),
            restoreButton.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor),
        ])
    }

    //MARK: - Handle user events
    @objc
    private func purchasePressed(_ sender: UIButton) {
        //helper.buyProduct(product!)
        SwiftyStoreKit.purchaseProduct("FirstInArchitectureCourseTest", quantity: 1, atomically: true) { result in
            switch result {
            case .success(purchase: let purchase):
                print(purchase)
                self.verifyPurchase()
            case .error(error: let error):
                print(error)
            }
        }
    }
    
    @objc
    private func restorePressed(_ sender: UIButton) {
        //helper.restorePurchases()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            } else {
                print("Nothing to Restore")
            }
        }
    }
    
    private func verifyPurchase() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "999")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                let productId = "FirstInArchitectureCourseTest"
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Verify receipt failed: \(error)")
            }
        }
    }
}

//MARK: - Supporting methods
extension PurchaseView {

    private func showSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }

    private func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

protocol PurchaseDelegate {
    func purchase()
}
