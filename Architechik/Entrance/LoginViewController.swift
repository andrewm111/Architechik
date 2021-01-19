//
//  LoginViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 02.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    //MARK: - Subviews
    private let loginButton: ASAuthorizationAppleIDButton = {
        let view = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        //view.setImage(UIImage(named: "signInApple"), for: .normal)
        view.contentMode = .scaleToFill
        //view.imageView?.contentMode = .scaleToFill
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        //view.backgroundColor = UIColor(displayP3Red: 106 / 255, green: 25 / 255, blue: 164 / 255, alpha: 1)
        view.contentMode = .scaleAspectFill
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //performExistingAccountSetupFlows()
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
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
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
