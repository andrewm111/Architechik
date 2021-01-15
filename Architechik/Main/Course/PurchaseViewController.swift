//
//  PurchaseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 15.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {

    //MARK: - Subviews
    private let purchaseButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 20
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        view.backgroundColor = .systemBlue
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let restoreButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 20
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "Restore purchase", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        view.backgroundColor = .systemBlue
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    var product: SKProduct?
    var helper: IAPHelper = IAPHelper(productIds: ["FirstInArchitectureCourseTest"])

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.backgroundColor = .white
        //showSpinner()
        helper.requestProducts { (success, products) in
            self.product = products?.first
            print("---Request products---")
            print(success)
            print(products ?? "Products is nil")
            print("---Request products---")
            guard let _ = self.product else {
                print("Product is nil in PurchaseVC")
                return
            }
            
        }
        
        purchaseButton.addTarget(self, action: #selector(purchasePressed), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restorePressed), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(purchaseButton)
        view.addSubview(restoreButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            purchaseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            purchaseButton.heightAnchor.constraint(equalToConstant: 50),
            purchaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            restoreButton.heightAnchor.constraint(equalToConstant: 50),
            restoreButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    //MARK: - Handle user events
    @objc
    private func purchasePressed(_ sender: UIButton) {
        helper.buyProduct(product!)
    }
    
    @objc
    private func restorePressed(_ sender: UIButton) {
        helper.restorePurchases()
    }

}

//MARK: - Supporting methods
extension PurchaseViewController {

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
