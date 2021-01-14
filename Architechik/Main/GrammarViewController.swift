//
//  GrammarViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class GrammarViewController: UIViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let filterButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBlue
        view.setImage(UIImage(named: "filter"), for: .normal)
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
        view.backgroundColor = UIColor(hex: "1F1F24")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 50),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
    
    //MARK: - Supporting methods
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GrammarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
