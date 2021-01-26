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
        //view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let infoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.text = "Тут мы собрали все\nнеобходимые материалы \nиз более чем 20\nисточников и\nадаптировали их под тебя!"
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
        
        let width = UIScreen.main.bounds.width
        let ratio: CGFloat = 0.497502497502498
        let height = width * ratio
        
        NSLayoutConstraint.activate([
            appDescriptionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            appDescriptionImageView.heightAnchor.constraint(equalToConstant: height),
            appDescriptionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appDescriptionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infoLabel.topAnchor.constraint(equalTo: appDescriptionImageView.bottomAnchor, constant: 12),
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: appDescriptionImageView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: appDescriptionImageView.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.075525812619503),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }

}
