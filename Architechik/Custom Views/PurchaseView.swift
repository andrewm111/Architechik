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

class PurchaseView: UIView, CardViewProtocol {
    
    //MARK: - Subviews
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = UIImage(named: "purchaseSuccess")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "buttonBlack")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .white
        view.text = "Открыть курс"
        view.font = UIFont(name: "Arial", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    var height: CGFloat = 200
    private var delegate: PurchaseViewDelegate?
    
    //MARK: - Init
    convenience init(withDelegate delegate: PurchaseViewDelegate) {
        self.init(frame: .zero)
        self.delegate = delegate
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
//        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = UIColor(hex: "1F1F24")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        buttonImageView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(buttonImageView)
        buttonImageView.addSubview(titleLabel)
        
        if let imageViewWidth = imageView.image?.size.width, let imageViewHeight = imageView.image?.size.height {
            let ratio = imageViewWidth / imageViewHeight
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: ratio).isActive = true
        }
        if let buttonViewWidth = buttonImageView.image?.size.width, let buttonViewHeight = buttonImageView.image?.size.height {
            let ratio = buttonViewWidth / buttonViewHeight
            buttonImageView.widthAnchor.constraint(equalTo: buttonImageView.heightAnchor, multiplier: ratio).isActive = true
        }
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -37),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            buttonImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            buttonImageView.heightAnchor.constraint(equalToConstant: 66),
            
            titleLabel.centerXAnchor.constraint(equalTo: buttonImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: buttonImageView.centerYAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: buttonImageView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: buttonImageView.bottomAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: buttonImageView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonImageView.trailingAnchor, constant: -5),
        ])
    }
    
    //MARK: - Handle user events
    @objc
    private func buttonTapped() {
        delegate?.close()
    }
}

protocol PurchaseViewDelegate {
    func close()
}





/*
SwiftyStoreKit.restorePurchases(atomically: true) { results in
if results.restoreFailedPurchases.count > 0 {
print("Restore Failed: \(results.restoreFailedPurchases)")
} else if results.restoredPurchases.count > 0 {
print("Restore Success: \(results.restoredPurchases)")
} else {
print("Nothing to Restore")
}
}
*/
