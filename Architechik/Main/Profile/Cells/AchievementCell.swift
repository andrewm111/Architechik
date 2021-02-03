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
    private let achievementImageView: WebImageView = {
        let view = WebImageView()
        view.layer.cornerRadius = 40
        view.backgroundColor = UIColor(hex: "613191")
        view.image = UIImage(named: "bumagaFull")
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
        view.numberOfLines = 2
        view.lineBreakMode = .byClipping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 15)
        view.numberOfLines = 0
        view.textColor = .white
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

    func configure(withModel model: Achievement) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        achievementImageView.set(imageURL: model.imgGood)
        selectionStyle = .none
        backgroundColor = .clear
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
            achievementImageView.heightAnchor.constraint(equalToConstant: 80),
            achievementImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: achievementImageView.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
    func getImage() -> UIImage? {
        return achievementImageView.image
    }
}
