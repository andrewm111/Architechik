//
//  HelloViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class HelloViewController: IndexableViewController {
    
    private let helloImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "hello")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let topLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.text = "Рад видеть тебя в нашем\nприложении"
        view.numberOfLines = 2
        //view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bottomLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.text = "Нам предстоит узнать\nмного всего интересного"
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "right")
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
        view.addSubview(helloImageView)
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            helloImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            helloImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            topLabel.topAnchor.constraint(equalTo: helloImageView.bottomAnchor, constant: 30),
            topLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            topLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: -30),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            bottomLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            bottomLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.topAnchor, constant: -6),
            bottomLabel.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.788920056100982),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        //helloImageView.heightAnchor.constraint(equalToConstant: 50),
        //helloImageView.widthAnchor.constraint(equalTo: helloImageView.heightAnchor, multiplier: 4.276923076923077),
    }
}


