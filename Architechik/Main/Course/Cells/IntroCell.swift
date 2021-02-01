//
//  IntroCell.swift
//  Architechik
//
//  Created by Александр Цветков on 30.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class IntroCell: TableViewCell {
    
    //MARK: - Subviews
    let mainView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "button")
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        //view.layer.cornerRadius = 25
        //view.backgroundColor = UIColor(hex: "613191")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let introLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 21)
        view.textAlignment = .center
        view.text = "Узнать больше о курсе"
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var delegate: IntroDelegate?

    func configure(withDelegate delegate: IntroDelegate) {
        self.delegate = delegate
        selectionStyle = .none
        backgroundColor = .clear
        initialSetup()
        setupSubviews()
    }

    //MARK: - Setup
    private func initialSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(introTapped))
        mainView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addSubview(mainView)
        mainView.addSubview(introLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IntroButton.spacing.rawValue),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -IntroButton.spacing.rawValue),
            
            introLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            introLabel.leadingAnchor.constraint(greaterThanOrEqualTo: mainView.leadingAnchor, constant: 10),
            introLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainView.trailingAnchor, constant: -10),
            introLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            introLabel.topAnchor.constraint(greaterThanOrEqualTo: mainView.topAnchor, constant: 5),
            introLabel.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -5),
        ])
    }
    
    //MARK: - Handle user events
    @objc
    private func introTapped() {
        delegate?.showIntro()
    }
}

enum IntroButton: CGFloat {
    case width = 952
    case height = 170
    case spacing = 25
    
    static func getWidthOnHeightRatio() -> CGFloat {
        return width.rawValue / height.rawValue
    }
    
    static func getHeightOnWidthRatio() -> CGFloat {
        return height.rawValue / width.rawValue
    }
}

protocol IntroDelegate {
    func showIntro()
}
