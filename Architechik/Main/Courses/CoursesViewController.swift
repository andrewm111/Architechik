//
//  CoursesViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import SQLite3

class CoursesViewController: ViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let testButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 25
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "Пройти вводный тест", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black])
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()
    private let filterButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBlue
        view.setImage(UIImage(named: "menuIcon"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.backgroundColor = UIColor(hex: "1F1F24")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(testButton)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 50),
            filterButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -20),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            testButton.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            testButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -6),
        ])
    }
    
    //MARK: - Supporting methods
    @objc
    private func cellTapped() {
        let vc = CourseViewController()
        vc.isModalInPopover = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.tabBarController?.tabBar.isHidden = true
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.window!.layer.add(transition, forKey: nil)
        present(vc, animated: true)
//        let tapLocation = tap.location(in: tableView)
//        guard let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) else { return }
//        let tappedCell = tableView.cellForRow(at: tapIndexPath) as? CourseCell
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CourseCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure()
        return cell
    }
}

