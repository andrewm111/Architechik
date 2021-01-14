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
        return UIScreen.main.bounds.height < 740
    }
    
    func addDismissKeyboardByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    
    var smallScreen: Bool {
        return UIScreen.main.bounds.height < 740
    }
    
    func addDismissKeyboardByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
