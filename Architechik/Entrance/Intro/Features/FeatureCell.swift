//
//  FeatureCell.swift
//  Architechik
//
//  Created by Александр Цветков on 22.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class FeatureCell: TableViewCell {
    
    private let featureImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let featureLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "222222")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func configure(forType type: FeatureType) {
        selectionStyle = .none
        backgroundColor = .clear
        initialSetup(forType: type)
        setupSubviews(forType: type)
    }
    
    //MARK: - Setup
    private func initialSetup(forType type: FeatureType) {
        switch type {
        case .course:
            featureLabel.text = "Пройти курс по\nнужной тебе теме"
            featureImageView.image = UIImage(named: "courseIcon")
        case .article:
            featureLabel.text = "Прочитать\nстатьи"
            featureImageView.image = UIImage(named: "articleIcon")
        case .grammar:
            featureLabel.text = "Вспомнить\nграмматику"
            featureImageView.image = UIImage(named: "grammarIcon")
        case .achievement:
            featureLabel.text = "Получить\nдостижение"
            featureImageView.image = UIImage(named: "achievementIcon")
        }
    }

    private func setupSubviews(forType type: FeatureType) {
        addSubview(featureImageView)
        addSubview(featureLabel)
        switch type {
        case .course:
            createLeftLayout(ratio: 0.767578125)
            addSeparator()
        case .article:
            createRightLayout(ratio: 0.826171875)
            addSeparator()
        case .grammar:
            createLeftLayout(ratio: 0.898238747553816)
            addSeparator()
        case .achievement:
            createRightLayout(ratio: 0.79296875)
        }
    }
    
    private func createLeftLayout(ratio: CGFloat) {
        NSLayoutConstraint.activate([
            featureImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            featureImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            featureImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            featureImageView.widthAnchor.constraint(equalTo: featureImageView.heightAnchor, multiplier: ratio),
            
            featureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            featureLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            featureLabel.leadingAnchor.constraint(equalTo: featureImageView.trailingAnchor, constant: 18),
            featureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func createRightLayout(ratio: CGFloat) {
        NSLayoutConstraint.activate([
            featureImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            featureImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            featureImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            featureImageView.widthAnchor.constraint(equalTo: featureImageView.heightAnchor, multiplier: ratio),
            
            featureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            featureLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            featureLabel.trailingAnchor.constraint(equalTo: featureImageView.leadingAnchor, constant: -38),
            featureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
        ])
    }
    
    private func addSeparator() {
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

enum FeatureType: CaseIterable {
    case course
    case article
    case grammar
    case achievement
}
