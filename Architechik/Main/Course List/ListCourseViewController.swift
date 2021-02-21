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
    private lazy var filterBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "613191")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    private lazy var filterView: FilterView = {
//        let view = FilterView(withCategoryName: "course")
//        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
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
            if models.count != 0 {
                
                if models.first?.idProduct != "" {
                    retrieveProducts()
                }
                tableView.reloadData()
            }
        }
    }
    var filteredModels: Array<Course> = []
    var lessons: Array<Lesson> = []
    private var cellHeights: Array<CGFloat> = []
    var products: Set<SKProduct> = []
    private var currentCategory: Int = -1
    //private lazy var filterViewConstraint = filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 280 + bottomPadding)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard Reachability.isConnectedToNetwork() else {
            showNetworkAlert()
            return
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setProgress), name: NSNotification.Name("SetProgress"), object: nil)
        //retrieveProducts()
        configureTableView()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterBackView.addGestureRecognizer(tap1)
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: ["category": -1])
    }
    
    private func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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
        let products = models.map { course -> String in
            return course.idProduct
        }
        let setProducts = Set<String>(products)
        //print(setProducts)
        SwiftyStoreKit.retrieveProductsInfo(setProducts) { result in
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
        view.addSubview(filterBackView)
        
        let filterSize: CGFloat = UIScreen.main.bounds.height * 0.07696428571428571
        //let filterSize: CGFloat = smallScreen ? 40 : 60
        filterBackView.layer.cornerRadius = filterSize / 2
        let filterBottomSpacing: CGFloat = eightPlusOrLess ? 30 : 50
        let filterTrailingSpacing: CGFloat = eightPlusOrLess ? 18 : 26
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterBackView.heightAnchor.constraint(equalToConstant: filterSize),
            filterBackView.widthAnchor.constraint(equalToConstant: filterSize),
            filterBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30 - filterBottomSpacing - bottomPadding),
            filterBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -filterTrailingSpacing),
        ])
    }
    
    //MARK: - Supporting methods
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
        tableView.reloadData()
    }
    
    @objc
    private func categoryChanged(_ notification: Notification) {
        guard
            let category = notification.userInfo?["category"] as? Int,
            let name = notification.userInfo?["categoryName"] as? String,
            name == "course"
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
        self.filterVC.view.frame = CGRect(x: 0, y: height, width: width, height: self.filterHeight)
        UIView.animate(withDuration: 0.2) {
            self.filterVC.view.frame = CGRect(x: 0, y: height - self.filterHeight, width: width, height: self.filterHeight)
        } completion: { _ in
            self.filterIsHidden = false
        }
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
