//
//  ProfileViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Subviews
    private let avatarView: UIImageView = {
        let view = UIImageView()
        //view.backgroundColor = .systemBlue
        view.image = UIImage(named: "avatar")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 75
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let progressLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 18)
        view.textColor = UIColor(hex: "613191")
        view.text = "Кол-во пройденных курсов"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.layer.cornerRadius = 3
        view.progressTintColor = UIColor(hex: "613191")
        view.progress = 0.75
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }

    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        view.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AchievementCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
    }
    
    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(avatarView)
        view.addSubview(progressLabel)
        view.addSubview(progressView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 150),
            avatarView.heightAnchor.constraint(equalToConstant: 150),
            
            progressLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 30),
            progressLabel.heightAnchor.constraint(equalToConstant: 24),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AchievementCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure()
        return cell
    }
    
    
}
