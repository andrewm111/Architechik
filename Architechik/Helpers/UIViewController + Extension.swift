//
//  UIViewController + Extension.swift
//  Architechik
//
//  Created by Александр Цветков on 14.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var smallScreen: Bool {
        return UIScreen.main.bounds.height < 600
    }
    
    func addDismissKeyboardByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addTabBarSeparator() {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(hex: "222222")
        view.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension UIView {
    
    var smallScreen: Bool {
        return UIScreen.main.bounds.height < 600
    }
    
    func addDismissKeyboardByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
