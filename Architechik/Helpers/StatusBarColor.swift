//
//  StatusBarColor.swift
//  Architechik
//
//  Created by Александр Цветков on 07.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var statusBarView: UIView {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let barView = UIView(frame: statusBarFrame)
        return barView
    }

    func setStatusBar(backgroundColor: UIColor) {
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

    func setStatusBarToDefault() {
        statusBarView.removeFromSuperview()
    }
}
