//
//  AchievementCell.swift
//  Architechik
//
//  Created by Александр Цветков on 10.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class AchievementCell: TableViewCell {
    
    //MARK: - Subviews
    private let achievementImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.backgroundColor = UIColor(hex: "613191")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 17)
        view.textColor = UIColor(hex: "613191")
        view.text = "How to tell about your project"
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 16)
        view.numberOfLines = 0
        view.textColor = UIColor(hex: "613191")
        view.text = "Ты получил ачивку.Ты получил ачивку.Ты получил ачивку.Ты получил ачивку.Ты получил ачивку."
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "222222")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func configure() {
        super.configure()
        initialSetup()
        setupSubviews()
    }
    
    private func initialSetup() {
        isUserInteractionEnabled = true
    }

    private func setupSubviews() {
        addSubview(achievementImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            achievementImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            achievementImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            achievementImageView.heightAnchor.constraint(equalToConstant: 100),
            achievementImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: achievementImageView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
}
