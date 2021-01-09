//
//  CourseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class CourseViewController: ViewController {
    
    //MARK: - Subviews
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(hex: "1F1F24")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 18)
        view.textColor = .white
        view.text = "History of architecture"
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 15)
        view.textColor = .white
        view.text = "Этот курс - большой сборник архитектурных терминов и упражнений, чтобы легко ориентироваться в англоязычных текстах про любой стиль и эпоху."
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let unlockButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 25
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "Начать", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black])
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
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
        view.backgroundColor = UIColor(hex: "1F1F24")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }

    private func setupSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(tableView)
        view.addSubview(unlockButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 30),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: titleView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: titleView.bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            descriptionLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: unlockButton.topAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            unlockButton.heightAnchor.constraint(equalToConstant: 50),
            unlockButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            unlockButton.widthAnchor.constraint(equalToConstant: 120),
            unlockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure()
        return cell
    }
}
