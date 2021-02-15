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
            var width: CGFloat = 0
            if progress <= 0 || self.frame.width <= 0 {
                width = 0
            } else {
                width = self.frame.width * progress
            }
            progressLayer.frame = CGRect(x: 0, y: 0, width: width, height: 6)
        }
    }
    private lazy var progressLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 0, height: 6)
        layer.cornerRadius = 3
        layer.backgroundColor = UIColor(hex: "613191").cgColor
        return layer
    }()
    
    //MARK: - Init
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
    
    //MARK: - External methods
    func setProgressForCourses(_ progress: CGFloat) {
        let width = UIScreen.main.bounds.width - 40
        progressLayer.frame = CGRect(x: 0, y: 0, width: width * progress, height: 6)
    }
}
