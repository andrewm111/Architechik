//
//  LoginViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 02.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Subviews
    private let loginButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "signInApple"), for: .normal)
        view.contentMode = .scaleToFill
        view.imageView?.contentMode = .scaleToFill
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        //view.image = UIImage(named: "")
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "Architechik"
        view.textColor = .purple
        view.font = UIFont(name: "Arial-BoldMT", size: 44)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "курсы для архитекторов"
        view.textColor = .purple
        view.font = UIFont(name: "Arial", size: 30)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }

    //MARK: - Supporting methods
    private func initialSetup() {
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(loginButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.62),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            subtitleLabel.heightAnchor.constraint(equalToConstant: 32),
            subtitleLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            loginButton.heightAnchor.constraint(equalToConstant: 58),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
        ])
    }
    
    //MARK: - User events handling
    @objc private func loginButtonTapped() {
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }

}

