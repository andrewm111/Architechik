//
//  ListCourseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import CoreData
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
            if models.count != 0 { tableView.reloadData() }
        }
    }
    var filteredModels: Array<Course> = []
    var lessons: Array<Lesson> = []
    private var cellHeights: Array<CGFloat> = []
    var products: Set<SKProduct> = []
    private var currentCategory: Int = -1
    private lazy var filterViewConstraint = filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 280 + bottomPadding)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard Reachability.isConnectedToNetwork() else {
            showNetworkAlert()
            return
        }
        
//        var frame = self.tabBarController?.tabBar.frame
//        let height = frame?.size.height
//        frame?.origin.y = self.view.frame.size.height + height!
//        self.tabBarController?.tabBar.frame = frame!
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.tabBarController?.tabBar.alpha = 0
    }
    
    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setProgress), name: NSNotification.Name("SetProgress"), object: nil)
        retrieveProducts()
        configureTableView()
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
//        let tap1 = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
//        filterButton.addGestureRecognizer(tap1)
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
//        let width = UIScreen.main.bounds.width
//        filterView.frame = CGRect(x: 0, y: 0, width: width, height: 280)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: filterSize),
            filterButton.widthAnchor.constraint(equalToConstant: filterSize),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80 - bottomPadding),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            filterView.heightAnchor.constraint(equalToConstant: 280),
            filterViewConstraint,
            filterView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
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
            //self.tabBarController?.tabBar.isHidden = false
            self.filterView.hide { _ in
                self.tableView.isScrollEnabled = true
                self.filterView.isHidden = true
                UIView.animate(withDuration: 0.2) {
                    self.tabBarController?.tabBar.alpha = 1
                } completion: { _ in }
            }
            //self.tabBarController?.tabBar.isTranslucent = false
//            DispatchQueue.main.async {
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController?.tabBar.isTranslucent = false
//                self.filterViewConstraint.constant = 280
//                UIView.animate(withDuration: 0.2) {
//                    self.view.layoutIfNeeded()
//                } completion: { _ in
//                    self.tableView.isScrollEnabled = true
//                    self.filterView.isHidden = true
//                }
//            }
            return
        }
        guard Reachability.isConnectedToNetwork() else {
            showNetworkAlert()
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let cell = tableView.cellForRow(at: tapIndexPath) as? CourseCell,
            models.count > tapIndexPath.row - 1
            else { return }
        let model = models[tapIndexPath.row - 1]
        let vc = CourseViewController()
        vc.product = products.first
        vc.modalPresentationStyle = .overFullScreen
        //vc.modalTransitionStyle = .coverVertical
        let filteredModels = lessons.filter({ lesson -> Bool in
            return lesson.idCourses == cell.model?.id
        })
        let sortedModels = filteredModels.sorted { (lesson1, lesson2) -> Bool in
            guard let id1 = Int(lesson1.id), let id2 = Int(lesson2.id) else { return false }
            return id1 < id2
        }
        guard NetworkDataFetcher.shared.studentProgress.count > tapIndexPath.row - 1 else { return }
        let studentProgress = NetworkDataFetcher.shared.studentProgress[tapIndexPath.row - 1]
        let progress = studentProgress.currentProgress
        var modelsWithProgress: Array<Lesson> = []
        for (index, model) in sortedModels.enumerated() {
            if progress.count - index - 1 >= 0 {
                let lessonProgress = progress.dropLast(progress.count - index - 1).last
                var newModel = model
                if lessonProgress == "1" { newModel.isDone = true } else { newModel.isDone = false }
                modelsWithProgress.append(newModel)
            } else {
                var newModel = model
                newModel.isDone = false
                modelsWithProgress.append(newModel)
            }
        }
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.coursePurchased = studentProgress.courseAccess == "1" ? true : false
        vc.models = modelsWithProgress
        vc.courseTitle = model.title
        vc.descriptionText = model.fullDescription
        vc.courseImageUrl = model.img
        vc.courseId = model.id
        self.present(vc, animated: false)
    }
    
    @objc
    private func setProgress() {
//        for i in 0...filteredModels.count {
//            guard
//                let progress = NetworkDataFetcher.shared.studentProgress.filter( { $0.idCourses == filteredModels[i].id } ).first,
//                let courseNumberInt = Int(filteredModels[i].courseNumber)
//                else {
//                    return
//            }
//            guard
//
//                let cell = tableView.cellForRow(at: IndexPath(row: i + 1, section: 0)) as? CourseCell
//                else {
//                    return
//            }
//            let courseNumberFloat = CGFloat(courseNumberInt)
//            let stringProgress = progress.currentProgress.dropFirst().filter( { "1".contains($0) } )
//            let currentProgress = CGFloat(stringProgress.count)
//            cell.progressView.setProgressForCourses(currentProgress / courseNumberFloat)
//        }
        tableView.reloadData()
    }
    
    @objc
    private func categoryChanged(_ notification: Notification) {
        guard
            let category = notification.userInfo?["category"] as? Int,
            let name = notification.userInfo?["categoryName"] as? String,
            name == "course"
            else { return }
        currentCategory = category
//        DispatchQueue.main.async {
//            self.filterViewConstraint.constant = 280
//            UIView.animate(withDuration: 0.2) {
//                self.view.layoutIfNeeded()
//            } completion: { _ in
//                self.tableView.isScrollEnabled = true
//                self.filterView.isHidden = true
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController?.tabBar.isTranslucent = false
//            }
//        }
        //self.tabBarController?.tabBar.isHidden = false
        //self.tabBarController?.tabBar.isTranslucent = false
        
        filterView.hide { _ in
            self.tableView.isScrollEnabled = true
            self.filterView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 1
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
        //self.tabBarController?.tabBar.isHidden = false
        //self.tabBarController?.tabBar.isTranslucent = false
        //filterView.isHidden = true
    }
    
    @objc
    private func filterButtonTapped() {
        UIView.animate(withDuration: 3.2) {
            //self.tabBarController?.tabBar.alpha = 0
//            let oldFrame = self.tabBarController!.tabBar.frame
//            self.tabBarController?.tabBar.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY + 100, width: oldFrame.width, height: oldFrame.height)
        } completion: { _ in
            //self.tabBarController?.tabBar.isHidden = true
            self.tableView.isScrollEnabled = false
            self.filterView.show {_ in}
        }
//        DispatchQueue.main.async {
//            self.tabBarController?.tabBar.isTranslucent = true
//            self.tabBarController?.tabBar.isHidden = true
//            self.tableView.isScrollEnabled = false
//            self.filterView.isHidden = false
//            self.filterViewConstraint.constant = 0
//            UIView.animate(withDuration: 3.2) {
//                self.view.layoutIfNeeded()
//            } completion: { _ in
//
//            }
//        }
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
                setProgressForCell(cell, modelIndex: indexPath.row - 1)
            }
            return cell
        }
    }
    
    private func setProgressForCell(_ cell: CourseCell, modelIndex: Int) {
            guard
                let progress = NetworkDataFetcher.shared.studentProgress.filter( { $0.idCourses == filteredModels[modelIndex].id } ).first,
                let courseNumberInt = Int(filteredModels[modelIndex].courseNumber)
                else {
                    return
        }
        
        let courseNumberFloat = CGFloat(courseNumberInt)
        let stringProgress = progress.currentProgress.dropFirst().filter( { "1".contains($0) } )
        let currentProgress = CGFloat(stringProgress.count)
        cell.progressView.setProgressForCourses(currentProgress / (courseNumberFloat - 1))
        }
}

//MARK: - WebDelegate
extension ListCourseViewController: WebDelegate {
    func enablePanGestureRecognizer() {}
}
