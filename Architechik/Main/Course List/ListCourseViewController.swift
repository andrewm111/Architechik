//
//  ListCourseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class ListCourseViewController: ViewController {
    
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
        view.backgroundColor = UIColor(hex: "613191")
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
        let view = FilterView(withCategoryName: "course")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    lazy var jsonPath = Bundle.main.path(forResource: "courses", ofType: "json")
    var models: Array<Course> = [] {
        didSet {
            if currentCategory == -1 {
                filteredModels = models
            } else {
                filteredModels = models.filter { model -> Bool in
                    return model.idCategory == "\(currentCategory)"
                }
            }
            tableView.reloadData()
        }
    }
    var filteredModels: Array<Course> = []
    private var cellHeights: Array<CGFloat> = []
    var products: Set<SKProduct> = []
    private var currentCategory: Int = -1

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for i in 0...filteredModels.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CourseCell {
                cell.progressView.progress = 0.75
            }
        }
    }
    
    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        retrieveProducts()
        configureTableView()
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: ["category": -1])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseCell.self)
        tableView.register(TitleCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
    }
    
    private func retrieveProducts() {
        SwiftyStoreKit.retrieveProductsInfo(["FirstInArchitectureCourseTest"]) { result in
            self.products = result.retrievedProducts
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice
                print("Product: \(product.localizedDescription), price: \(String(describing: priceString))")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId) in \(#function)")
            } else {
                print("Error: \(String(describing: result.error)) in \(#function)")
            }
        }
    }

    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        //view.addSubview(testButton)
        view.addSubview(filterButton)
        view.addSubview(filterView)
        
        let filterSize: CGFloat = smallScreen ? 40 : 60
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: filterSize),
            filterButton.widthAnchor.constraint(equalToConstant: filterSize),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            filterView.heightAnchor.constraint(equalToConstant: 280),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 370),
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
        guard filterView.isHidden else {
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.tabBar.isTranslucent = false
            filterView.hide { _ in
                self.tableView.isScrollEnabled = true
                self.filterView.isHidden = true
            }
            return
        }
        let vc = CourseViewController()
        vc.product = products.first
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
         let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let cell = tableView.cellForRow(at: tapIndexPath) as? CourseCell
            else { return }
        let model = models[tapIndexPath.row - 1]
        NetworkDataFetcher.shared.fetchCourseStructure { lessons in
            vc.models = lessons.filter({ lesson in
                return lesson.idCourses == cell.model?.id
            })
            vc.courseTitle = model.title
            vc.descriptionText = model.fullDescription
            vc.courseImageUrl = model.img
            vc.courseId = model.id
            self.present(vc, animated: true)
        }
    }
    
    @objc
    private func categoryChanged(_ notification: Notification) {
        guard
            let category = notification.userInfo?["category"] as? Int,
            let name = notification.userInfo?["categoryName"] as? String,
            name == "course"
            else { return }
        currentCategory = category
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        filterView.hide { _ in
            self.tableView.isScrollEnabled = true
            self.filterView.isHidden = true
        }
        if category == -1 {
            filteredModels = models
        } else {
            filteredModels = models.filter { model -> Bool in
                return model.idCategory == "\(category)"
            }
        }
        tableView.reloadData()
//        self.tabBarController?.tabBar.isHidden = false
//        self.tabBarController?.tabBar.isTranslucent = false
        //filterView.isHidden = true
    }
    
    @objc
    private func filterButtonTapped() {
        //self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.isScrollEnabled = false
        //filterView.isHidden = false
        filterView.show { _ in
            
        }
        //filterView.frame = CGRect(x: 0, y: 629, width: 375, height: 200)
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListCourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let font = UIFont(name: "Arial", size: 15) ?? UIFont.systemFont(ofSize: 15)
//        let width = UIScreen.main.bounds.width - 16
//        let string = models[indexPath.row].description
//        let height = string.height(width: width, font: font) + 129
//        return height
        guard indexPath.row != 0 else { return 60 }
        return 230
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: TitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(withTitle: "Courses")
            return cell
        default:
            let cell: CourseCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if filteredModels.count >= indexPath.row - 2 {
                cell.configure(withModel: filteredModels[indexPath.row - 1])
            }
            return cell
        }
    }
}

