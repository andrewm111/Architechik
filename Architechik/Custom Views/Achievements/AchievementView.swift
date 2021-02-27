//
//  AchievementView.swift
//  Architechik
//
//  Created by Александр Цветков on 26.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

final class AchievementView: UIView, CardViewProtocol {
    
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
        //view.layer.cornerRadius = 66.875
        view.backgroundColor = UIColor(hex: "613191")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 20)
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
        view.font = UIFont(name: "Arial", size: 15)
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
        view.image = UIImage(named: "share")?.withTintColor(.black)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = .black
        view.text = "Отправить"
        view.font = UIFont(name: "Arial-BoldMT", size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    private var delegate: SharingDelegate?
    private var model: Achievement?
    var height: CGFloat = 300
    private let bottomPadding: CGFloat = {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets.bottom
    }()
    
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
        backgroundColor = UIColor(hex: "1F1F24")
        
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
        
        //let buttonViewHeight: CGFloat = (delegate.achievementHeight - delegate.bottomPadding - 49) / 4
        let buttonViewHeight: CGFloat = ((UIScreen.main.bounds.height * 0.344827586206897) - bottomPadding - 20) / 4
        //let backViewHeight = (UIScreen.main.bounds.height * 0.312807881773399) - buttonViewHeight - bottomPadding - 49
        //let imageViewHeight: CGFloat = (buttonViewHeight * 3) - 20
        guard let delegate = self.delegate else { return }
        let backViewHeight: CGFloat = delegate.achievementHeight - (2 * delegate.bottomPadding) - 49 - buttonViewHeight
        let backViewWidth: CGFloat = UIScreen.main.bounds.width - 20
        var imageViewHeight: CGFloat = (backViewWidth / 3)
        var textWidth: CGFloat = imageViewHeight * 2
        
        if imageViewHeight > backViewHeight - 20 {
            imageViewHeight = backViewHeight - 20
            textWidth = backViewWidth - 30 - imageViewHeight
        }
        imageView.layer.cornerRadius = imageViewHeight / 2
        
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            //backView.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 3),
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            imageView.topAnchor.constraint(greaterThanOrEqualTo: backView.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: backView.bottomAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: textWidth),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -2),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            
            descriptionLabel.widthAnchor.constraint(equalToConstant: textWidth),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: backView.bottomAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            buttonView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 15),
            buttonView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            buttonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24 - bottomPadding),
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
    
    func roundImageView() {
        print(imageView.frame)
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    func configure(withModel model: Achievement, image: UIImage?) {
        self.model = model
        titleLabel.text = model.title
        imageView.image = image
        
        descriptionLabel.text = model.progress == 1 ? model.description : "Пройди курс чтобы открыть достижение"
    }
    
    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            backView.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 3),
//            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//
//            imageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
//            imageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
//            imageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
//            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
//
//            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -2),
//            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -2),
//            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
//
//            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: backView.bottomAnchor, constant: -5),
//            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//
//            buttonView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 15),
//            buttonView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
//            buttonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24 - bottomPadding),
//            buttonView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
//            buttonView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
//
//            shareIcon.heightAnchor.constraint(equalTo: shareIcon.heightAnchor),
//            shareIcon.widthAnchor.constraint(equalToConstant: shareIconWidth),
//            shareIcon.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
//            shareIcon.trailingAnchor.constraint(equalTo: buttonLabel.leadingAnchor, constant: -10),
//            shareIcon.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: spacing),
//
//            buttonLabel.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 5),
//            buttonLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -5),
//            buttonLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: spacing),
//        ])
    }
    
    @objc
    private func shareTapped() {
        //guard model?.progress == 1 else { return }
        let descriptionText = descriptionLabel.text ?? "Я получил достижение в Architechik"
        let textToShare = model?.progress == 1 ? descriptionText : "Для открытия достижения пройдите курс"
        delegate?.shareTapped(image: imageView.image, text: textToShare)
    }
}

protocol SharingDelegate {
    var achievementHeight: CGFloat { get set }
    var bottomPadding: CGFloat { get set }
    func shareTapped(image: UIImage?, text: String)
}
