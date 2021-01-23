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
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBlue
        view.setImage(UIImage(named: "filter"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let filterView: FilterView = {
        let view = FilterView(withCategoryName: "grammar")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    lazy var jsonPath = Bundle.main.path(forResource: "grammar", ofType: "json")
    var models: Array<Grammar> = []
    var filteredModels: Array<Grammar> = []

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
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        fetchJSON()
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: ["category": -1, "categoryName": "grammar"])
    }

    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        view.addSubview(filterButton)
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            filterView.heightAnchor.constraint(equalToConstant: 250),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 90),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - Events handling
    @objc
    private func categoryChanged(_ notification: Notification) {
        guard
            let category = notification.userInfo?["category"] as? Int,
            let name = notification.userInfo?["categoryName"] as? String,
            name == "grammar"
            else { return }
        if category == -1 {
            filteredModels = models
        } else {
            filteredModels = models.filter { model -> Bool in
                return model.category == "\(category)"
            }
        }
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        filterView.isHidden = true
    }
    
    @objc
    private func filterButtonTapped() {
        //self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        filterView.isHidden = false
        //filterView.frame = CGRect(x: 0, y: 629, width: 375, height: 200)
    }
    
    //MARK: - Supporting methods
    private func fetchJSON() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let path = jsonPath else { return }
        let jsonURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: jsonURL)
            let models = try decoder.decode([Grammar].self, from: data)
            self.models = models
        } catch {
            print("Error with converting json file to model")
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GrammarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(withDataSource: filteredModels[indexPath.row])
        cell.makeNotDone()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
