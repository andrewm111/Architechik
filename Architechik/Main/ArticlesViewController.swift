//
//  ArticlesViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class ArticlesViewController: ViewController {
    
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
//    private let filterView: FilterView = {
//        let view = FilterView(withCategoryName: "article")
//        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    private lazy var lessonView: LessonView = {
        let view = LessonView(withDelegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    lazy var jsonPath = Bundle.main.path(forResource: "articles", ofType: "json")
    var models: Array<Article> = [] {
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
    var filteredModels: Array<Article> = []
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    private var currentCategory: Int = -1
    //private lazy var filterViewConstraint = filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 280)
    private let bottomPadding: CGFloat = {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets.bottom
    }()
    private lazy var filterVC: FilterViewController = {
        let vc = FilterViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.filterView = FilterView(withCategoryName: "course")
        return vc
    }()
    private var filterIsHidden = true
    private lazy var filterHeight: CGFloat = UIScreen.main.bounds.height * 0.39
    
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
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: ["category": -1, "categoryName": "article"])
    }
    
    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        view.addSubview(filterButton)
        //view.addSubview(filterView)
        view.addSubview(lessonView)
        
        let filterSize: CGFloat = smallScreen ? 40 : 60
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom
        let filterBottomSpacing: CGFloat = eightPlusOrLess ? 30 : 50
        let filterTrailingSpacing: CGFloat = eightPlusOrLess ? 18 : 26
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: filterSize),
            filterButton.widthAnchor.constraint(equalToConstant: filterSize),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30 - filterBottomSpacing - bottomPadding),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -filterTrailingSpacing),
            
//            filterView.heightAnchor.constraint(equalToConstant: 280),
//            filterViewConstraint,
//            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            lessonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lessonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
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
            name == "article"
            else { return }
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.2) {
            self.filterVC.view.frame = CGRect(x: 0, y: height, width: width, height: self.filterHeight)
        } completion: { _ in
            self.tableView.isScrollEnabled = true
            self.filterIsHidden = true
            self.filterVC.willMove(toParent: nil)
            self.filterVC.view.removeFromSuperview()
            self.filterVC.removeFromParent()
        }
        currentCategory = category
        if category == -1 {
            filteredModels = models
        } else {
            filteredModels = models.filter { model -> Bool in
                return model.idCategory == "\(category)"
            }
        }
        tableView.reloadData()
    }
    
    @objc
    private func filterButtonTapped() {
        self.tableView.isScrollEnabled = false
        self.tabBarController?.addChild(filterVC)
        self.tabBarController?.view.addSubview(filterVC.view)
        filterVC.didMove(toParent: self.tabBarController)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        self.filterVC.view.frame = CGRect(x: 0, y: height, width: width, height: 280)
        UIView.animate(withDuration: 0.2) {
            self.filterVC.view.frame = CGRect(x: 0, y: height - self.filterHeight, width: width, height: self.filterHeight)
        } completion: { _ in
            self.filterIsHidden = false
        }
    }
    
    @objc
    private func cellTapped() {
        guard filterIsHidden else {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.2) {
                self.filterVC.view.frame = CGRect(x: 0, y: height, width: width, height: self.filterHeight)
            } completion: { _ in
                self.tableView.isScrollEnabled = true
                self.filterIsHidden = true
                self.filterVC.willMove(toParent: nil)
                self.filterVC.view.removeFromSuperview()
                self.filterVC.removeFromParent()
            }
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let _ = tableView.cellForRow(at: tapIndexPath) as? LessonCell
            else { return }
        guard Reachability.isConnectedToNetwork() else {
            showNetworkAlert()
            return
        }
        lessonView.showView()
        lessonView.urlString = filteredModels[tapIndexPath.row - 1].file
    }
    
    //MARK: - Supporting methods
    
    
}

//MARK: - WebDelegate
extension ArticlesViewController: WebDelegate {
    func enablePanGestureRecognizer() {
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: TitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(withTitle: "Articles")
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
