//
//  AppDescriptionViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class AppDescriptionViewController: IndexableViewController {
    
    private let appDescriptionImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "appDescription")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let infoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.text = "Тут мы собрали все\nнеобходимые материалы из\nболее чем 20 источников\nмирового уровня и\nадаптировали их под тебя!"
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "left")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.backgroundColor = .black
    }
    
    private func setupSubviews() {
        view.addSubview(appDescriptionImageView)
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.075525812619503),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            appDescriptionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            appDescriptionImageView.heightAnchor.constraint(equalTo: appDescriptionImageView.widthAnchor, multiplier: 0.715170278637771),
            appDescriptionImageView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -12),
            appDescriptionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appDescriptionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: appDescriptionImageView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: appDescriptionImageView.trailingAnchor),
        ])
    }

}
