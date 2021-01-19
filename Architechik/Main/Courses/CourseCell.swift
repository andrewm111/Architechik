//
//  CourseCell.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class CourseCell: TableViewCell {

    private lazy var backImageView: UIImageView = {
        let view = UIImageView()
        //view.backgroundColor = #colorLiteral(red: 0.3419600844, green: 0.5, blue: 0.4824177847, alpha: 1)
        view.image = UIImage(named: "backImage")
        view.contentMode = .scaleAspectFill
        let coverLayer = CALayer()
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 179)
        coverLayer.frame = rect
        coverLayer.backgroundColor = UIColor.black.cgColor
        view.layer.addSublayer(coverLayer)
        coverLayer.opacity = 0.6
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let numberOfLessonsLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "16 уроков"
        view.font = UIFont(name: "Arial", size: 15)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let lessonIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "paper")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        //view.text = "Бесплатно"
        view.font = UIFont(name: "Arial", size: 15)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        //view.text = "Вводный тест"
        view.font = UIFont(name: "Arial-BoldMT", size: 17)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        //view.text = "Определите свой уровень владения английским,и мы поможем вам выбрать подходящий курс"
        view.numberOfLines = 0
        view.font = UIFont(name: "Arial", size: 15)
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .black
        view.progressTintColor = .systemBlue
        view.progress = 0.75
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var model: Course?

    func configure(withModel model: Course) {
        self.model = model
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        priceLabel.text = "\(model.price) ₽"
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        selectionStyle = .none
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func setupSubviews() {
        addSubview(backImageView)
        backImageView.addSubview(numberOfLessonsLabel)
        backImageView.addSubview(lessonIcon)
        backImageView.addSubview(priceLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        backImageView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            backImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            backImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            lessonIcon.topAnchor.constraint(equalTo: backImageView.topAnchor, constant: 15),
            lessonIcon.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 12),
            lessonIcon.heightAnchor.constraint(equalToConstant: 25),
            lessonIcon.widthAnchor.constraint(equalToConstant: 24),
            
            numberOfLessonsLabel.centerYAnchor.constraint(equalTo: lessonIcon.centerYAnchor),
            numberOfLessonsLabel.leadingAnchor.constraint(equalTo: lessonIcon.trailingAnchor, constant: 6),
            numberOfLessonsLabel.heightAnchor.constraint(equalToConstant: 24),
            numberOfLessonsLabel.trailingAnchor.constraint(lessThanOrEqualTo: backImageView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: backImageView.topAnchor, constant: 17),
            priceLabel.heightAnchor.constraint(equalToConstant: 24),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: numberOfLessonsLabel.trailingAnchor, constant: 50),
            priceLabel.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: lessonIcon.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: backImageView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: progressView.topAnchor, constant: -4),
            
            progressView.heightAnchor.constraint(equalToConstant: 6),
            progressView.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: -12),
            progressView.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: -38),
        ])
    }
}

//MARK: - UIGestureRecognizerDelegate
extension CourseCell {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer || otherGestureRecognizer is UITapGestureRecognizer {
            return true
        } else {
            return false
        }
    }
}
