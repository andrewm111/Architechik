//
//  ProgressView.swift
//  Architechik
//
//  Created by Александр Цветков on 30.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    //MARK: - Properties
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width * progress, height: 6)
        }
    }
    private lazy var progressLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 0, height: 6)
        layer.cornerRadius = 3
        layer.backgroundColor = UIColor(hex: "613191").cgColor
        return layer
    }()

    convenience init(withProgress progress: CGFloat) {
        self.init(frame: .zero)
        self.progress = progress
        initialSetup()
    }

    //MARK: - Setup
    private func initialSetup() {
        layer.cornerRadius = 3
        clipsToBounds = true
        backgroundColor = UIColor(hex: "222222")
        layer.addSublayer(progressLayer)
    }
    
    
}