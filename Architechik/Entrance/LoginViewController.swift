//
//  LoginViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 02.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: IndexableViewController {
    
    //MARK: - Subviews
    private let loginButton: ASAuthorizationAppleIDButton = {
        let view = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        //view.setImage(UIImage(named: "signInApple"), for: .normal)
        view.contentMode = .scaleToFill
        //view.imageView?.contentMode = .scaleToFill
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    private let titleLabel: UILabel = {
//        let view = UILabel()
//        view.textAlignment = .center
//        view.text = "Architechik"
//        view.textColor = .purple
//        view.font = UIFont(name: "Arial-BoldMT", size: 44)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    private let titleImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "gradientTitle")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let welcomeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "Добро пожаловать!"
        view.textColor = .white
        view.font = UIFont(name: "Arial-BoldMT", size: 32)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    private let cardView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(hex: "613191")
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        view.layer.cornerRadius = 20
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    private let cardView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = UIImage(named: "gradientCard")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(true, forKey: "introShowed")
        //performExistingAccountSetupFlows()
    }
    
    //MARK: - Supporting methods
    private func initialSetup() {
        view.backgroundColor = .black
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(cardView)
        view.addSubview(loginButton)
        view.addSubview(imageView)
        view.addSubview(titleImageView)
        view.addSubview(welcomeLabel)
        loginButton.removeConstraints(loginButton.constraints)
        
        if let width = titleImageView.image?.size.width, let height = titleImageView.image?.size.height {
            let ratio = height / width
            titleImageView.heightAnchor.constraint(equalTo: titleImageView.widthAnchor, multiplier: ratio).isActive = true
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.52),
            imageView.bottomAnchor.constraint(equalTo: titleImageView.topAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            welcomeLabel.heightAnchor.constraint(equalToConstant: 34),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleImageView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -50),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            
            loginButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 58),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - User events handling
    @objc private func loginButtonTapped() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
        showTabBarController()
    }
    
    func performExistingAccountSetupFlows() {
        print(#function)
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func showTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }
}

//MARK: - ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print(#function)
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let token = appleIDCredential.identityToken
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let defaults = UserDefaults.standard
            defaults.set(userIdentifier, forKey: "userIdentifier")
            defaults.set(token, forKey: "token")
            
            if let givenName = fullName?.givenName, let middleName = fullName?.middleName, let email = email {
                defaults.set(email, forKey: "email")
                defaults.set("\(givenName) \(middleName)", forKey: "fullName")
                print("FullName: \(givenName) \(middleName)")
                print("Email: \(email)")
            } else {
                print("FullName: \(String(describing: fullName))")
                print("Email: \(String(describing: email))")
            }
            print("User identifier: \(userIdentifier)")
            self.saveInKeychain(userIdentifier)
            print("Token: \(String(describing: token?.hexEncodedString()))")
            showTabBarController()
        case let passwordCredential as ASPasswordCredential:
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            let defaults = UserDefaults.standard
            defaults.set(username, forKey: "username")
            defaults.set(password, forKey: "password")
            
            print("Username: \(username)")
            print("Password: \(password)")
            self.saveInKeychain(password)
            showTabBarController()
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    private func saveInKeychain(_ info: String) {
        do {
            try KeychainItem(service: "mikel.Shmonov.Architechik", account: "userIdentifier").saveItem(info)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
}
