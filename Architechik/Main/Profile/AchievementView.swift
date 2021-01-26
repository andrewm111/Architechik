//
//  AchievementView.swift
//  Architechik
//
//  Created by Александр Цветков on 26.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class AchievementView: UIView {
    
    //MARK: - Subviews
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = (((200 - 45) / 4) * 3 - 20) / 2
        view.backgroundColor = UIColor(hex: "613191")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 24)
        view.textColor = UIColor(hex: "613191")
        view.text = "Название"
        view.numberOfLines = 2
        view.textAlignment = .left
        view.lineBreakMode = .byClipping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 15)
        view.textColor = .white
        view.text = "Описание достижения"
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "613191")
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let shareIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "share")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = .white
        view.text = "Отправить"
        view.font = UIFont(name: "Arial-BoldMT", size: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    private var delegate: SharingDelegate?
    private var model: Achievement?
    
    convenience init(withModel model: Achievement?, delegate: SharingDelegate) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.model = model
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = UIColor(hex: "222222")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(shareTapped))
        buttonView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(descriptionLabel)
        backView.addSubview(imageView)
        addSubview(buttonView)
        buttonView.addSubview(shareIcon)
        buttonView.addSubview(buttonLabel)
        
        let shareIconWidth: CGFloat = 24
        let totalWidth: CGFloat = 24 + 10 + buttonLabel.intrinsicContentSize.width
        let spacing: CGFloat = (UIScreen.main.bounds.width - totalWidth) / 2
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backView.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 3),
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            imageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: backView.bottomAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            buttonView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 15),
            buttonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            buttonView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            
            shareIcon.heightAnchor.constraint(equalTo: shareIcon.heightAnchor),
            shareIcon.widthAnchor.constraint(equalToConstant: shareIconWidth),
            shareIcon.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            shareIcon.trailingAnchor.constraint(equalTo: buttonLabel.leadingAnchor, constant: -10),
            shareIcon.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: spacing),
            
            buttonLabel.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 5),
            buttonLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -5),
            buttonLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: spacing),
        ])
    }
    
    @objc
    private func shareTapped() {
        delegate?.shareTapped()
    }
}

protocol SharingDelegate {
    func shareTapped()
}
