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
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let achievementLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 18)
        view.textColor = .systemBlue
        view.text = "Достижение 1"
        view.textAlignment = .left
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
        addSubview(achievementLabel)
        
        NSLayoutConstraint.activate([
            achievementImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            achievementImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            achievementImageView.heightAnchor.constraint(equalToConstant: 50),
            achievementImageView.widthAnchor.constraint(equalToConstant: 50),
            
            achievementLabel.centerYAnchor.constraint(equalTo: achievementImageView.centerYAnchor),
            achievementLabel.heightAnchor.constraint(equalToConstant: 24),
            achievementLabel.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor, constant: 10),
            achievementLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
        ])
    }
}
