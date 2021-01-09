//
//  LessonCell.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class LessonCell: TableViewCell {
    
    private let backImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 16)
        view.textColor = .white
        view.text = "Вступление: Hey there! What's going on?"
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 16)
        view.textColor = .white
        view.lineBreakMode = .byWordWrapping
        view.text = "Небольшое вступление про курс, из чего состоит курс, что мы будем делать и где это использовать дальше"
        view.textAlignment = .left
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let doneLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 16)
        view.textColor = .white
        view.text = "Выполнено"
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let doneIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "menuIcon")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func  configure() {
        super.configure()
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        
    }
    
    private func setupSubviews() {
        addSubview(backImageView)
        backImageView.addSubview(titleLabel)
        backImageView.addSubview(descriptionLabel)
        backImageView.addSubview(doneLabel)
        backImageView.addSubview(doneIcon)
        
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            backImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            backImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            doneIcon.topAnchor.constraint(equalTo: backImageView.topAnchor, constant: 6),
            doneIcon.heightAnchor.constraint(equalToConstant: 24),
            doneIcon.widthAnchor.constraint(equalToConstant: 24),
            doneIcon.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: -6),
            
            doneLabel.centerYAnchor.constraint(equalTo: doneIcon.centerYAnchor),
            doneLabel.heightAnchor.constraint(equalTo: doneIcon.heightAnchor),
            doneLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backImageView.leadingAnchor, constant: 10),
            doneLabel.trailingAnchor.constraint(equalTo: doneIcon.leadingAnchor, constant: -5),
            
            titleLabel.topAnchor.constraint(equalTo: doneLabel.bottomAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: -10),
        ])
    }

}
