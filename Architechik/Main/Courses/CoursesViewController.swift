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
    private lazy var testButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 20
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "Пройти вводный тест", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black])
        view.setAttributedTitle(attributedString, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
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
        let view = FilterView(withCategoryName: "course")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    lazy var jsonPath = Bundle.main.path(forResource: "courses", ofType: "json")
    var models: Array<Course> = []
    var filteredModels: Array<Course> = []
    private var cellHeights: Array<CGFloat> = []

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        fetchJSON()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: ["category": -1])
    }

    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        //view.addSubview(testButton)
        view.addSubview(filterButton)
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
//        testButton.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor),
//        testButton.heightAnchor.constraint(equalToConstant: 30),
//        testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//        testButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -6),
    }
    
    //MARK: - Supporting methods
    @objc
    private func cellTapped() {
        let vc = CourseViewController()
        //vc.isModalInPopover = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.window!.layer.add(transition, forKey: nil)
         let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let _ = tableView.cellForRow(at: tapIndexPath) as? CourseCell
            else { return }
        present(vc, animated: true) {
            //self.tabBarController?.tabBar.isHidden = true
        }
       
        
    }
    
    @objc
    private func categoryChanged(_ notification: Notification) {
        guard let category = notification.userInfo?["category"] as? Int else { return }
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
    
    private func fetchJSON() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let path = jsonPath else { return }
        let jsonURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: jsonURL)
            let models = try decoder.decode([Course].self, from: data)
            self.models = models
        } catch {
            print("Error with converting json file to model")
        }
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let font = UIFont(name: "Arial", size: 15) ?? UIFont.systemFont(ofSize: 15)
//        let width = UIScreen.main.bounds.width - 16
//        let string = models[indexPath.row].description
//        let height = string.height(width: width, font: font) + 129
//        return height
        return 230
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CourseCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(withModel: filteredModels[indexPath.row])
        return cell
    }
}

