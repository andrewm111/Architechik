//
//  GrammarViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class GrammarViewController: ViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var filterButton: UIButton = {
        let view = UIButton(type: .custom)
        let radius: CGFloat = smallScreen ? 20 : 30
        view.layer.cornerRadius = radius
        view.backgroundColor = UIColor(hex: "613191")
        let image = smallScreen ? UIImage(named: "filterSmall") : UIImage(named: "filter")
        view.setImage(image, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let filterView: FilterView = {
        let view = FilterView(withCategoryName: "grammar")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var lessonView: LessonView = {
        let view = LessonView(withDelegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    lazy var jsonPath = Bundle.main.path(forResource: "grammar", ofType: "json")
    var models: Array<Grammar> = [] {
        didSet {
            if currentCategory == -1 {
                filteredModels = models
            } else {
                filteredModels = models.filter { model -> Bool in
                    return model.idCategory == "\(currentCategory)"
                }
            }
            if models.count != 0 { tableView.reloadData() }
        }
    }
    var filteredModels: Array<Grammar> = []
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    private var currentCategory: Int = -1
    private lazy var filterViewConstraint = filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 280)
    private let bottomPadding: CGFloat = {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets.bottom
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
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self)
        tableView.register(TitleCell.self)
        tableView.addGestureRecognizer(tap)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        
        lessonView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: ["category": -1, "categoryName": "grammar"])
    }
    
    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        view.addSubview(filterButton)
        view.addSubview(filterView)
        view.addSubview(lessonView)
        
        let filterSize: CGFloat = smallScreen ? 40 : 60
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: filterSize),
            filterButton.widthAnchor.constraint(equalToConstant: filterSize),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80 - bottomPadding),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            filterView.heightAnchor.constraint(equalToConstant: 280),
            filterViewConstraint,
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            lessonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lessonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lessonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lessonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        currentCategory = category
        DispatchQueue.main.async {
            self.filterViewConstraint.constant = 280
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.tableView.isScrollEnabled = true
                self.filterView.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.tabBar.isTranslucent = false
            }
        }
        if category == -1 {
            filteredModels = models
        } else {
            filteredModels = models.filter { model -> Bool in
                return model.idCategory == "\(category)"
            }
        }
        tableView.reloadData()
        
        //filterView.isHidden = true
    }
    
    @objc
    private func filterButtonTapped() {
        //self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.isScrollEnabled = false
        DispatchQueue.main.async {
            self.filterView.isHidden = false
            self.filterViewConstraint.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        //filterView.frame = CGRect(x: 0, y: 629, width: 375, height: 200)
    }
    
    @objc
    private func cellTapped() {
        guard filterView.isHidden else {
            DispatchQueue.main.async {
                self.filterViewConstraint.constant = 280
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.tableView.isScrollEnabled = true
                    self.filterView.isHidden = true
                    self.tabBarController?.tabBar.isHidden = false
                    self.tabBarController?.tabBar.isTranslucent = false
                }
            }
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let _ = tableView.cellForRow(at: tapIndexPath) as? LessonCell
            else { return }
//        let vc = WebViewController()
//        vc.urlString = filteredModels[tapIndexPath.row].file
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .coverVertical
//        present(vc, animated: true)
        guard Reachability.isConnectedToNetwork() else {
            showNetworkAlert()
            return
        }
        lessonView.showView()
        lessonView.urlString = filteredModels[tapIndexPath.row - 1].file
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

//MARK: - WebDelegate
extension GrammarViewController: WebDelegate {
    func enablePanGestureRecognizer() {
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GrammarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: TitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(withTitle: "Grammar")
            return cell
        default:
            let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if filteredModels.count >= indexPath.row - 2 {
                cell.configure(withDataSource: filteredModels[indexPath.row - 1])
                cell.setImage(imageString: filteredModels[indexPath.row - 1].img)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else { return 60 }
        return 140
    }
}
