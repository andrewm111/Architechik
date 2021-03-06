//
//  CourseCell.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class CourseCell: TableViewCell {

    private lazy var backImageView: WebImageView = {
        let view = WebImageView()
        //view.image = UIImage(named: "backImage")
        view.contentMode = .scaleAspectFill
        let coverLayer = CALayer()
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 210)
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
        view.text = "15 уроков"
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
    private lazy var priceStackView: UIStackView = {
        var views: Array<UIView> = []
        for i in 0...2 {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 20).isActive = true
            view.widthAnchor.constraint(equalToConstant: 20).isActive = true
            view.image = UIImage(named: "coffee")
            view.contentMode = .scaleAspectFit
            views.append(view)
        }
        let view = UIStackView(arrangedSubviews: views)
        view.axis = .horizontal
        view.spacing = 0
        view.distribution = .fillEqually
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
        //view.textColor = UIColor(hex: "613191")
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
    let progressView: ProgressView = {
        let view = ProgressView(withProgress: 0.75)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var model: Course?

    func configure(withModel model: Course) {
        self.model = model
        if let numberOfLessons = Int(model.courseNumber) {
            numberOfLessonsLabel.text = "\(numberOfLessons - 1) уроков"
        } else {
            numberOfLessonsLabel.text = "\(model.courseNumber) уроков"
        }
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        priceLabel.text = "  =  \(model.price) ₽"
        backImageView.set(imageURL: model.img)
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
        backImageView.addSubview(priceStackView)
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
            
            priceStackView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            priceStackView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            
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
