//
//  CourseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class CourseViewController: ViewController, SwipeToDismissControllerDelegate {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var purchaseView: PurchaseView = {
        let view = PurchaseView(withDelegate: self)
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
    var models: Array<Lesson> = [] {
        didSet {
            if models.count != 0 { tableView.reloadData() }
        }
    }
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(viewDragged))
    var product: SKProduct?
    //var helper: IAPHelper = IAPHelper(productIds: ["FirstInArchitectureCourseTest"])
    var descriptionText: String = ""
    var courseTitle: String = ""
    var courseImageUrl: String = ""
    var courseId: String = ""
    var coursePurchased = false {
        didSet {
            tableView.reloadData()
        }
    }

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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self)
        tableView.register(DescriptionCell.self)
        tableView.register(UnlockCell.self)
        tableView.register(CourseTitleCell.self)
        tableView.register(IntroCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
        lessonView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
//        guard
//        let product = product,
//        let price = product.localizedPrice
//        else { return }
        //let attributedString = NSAttributedString(string: product.localizedTitle + " за " + price, attributes: purchaseView.attributes)
        //purchaseView.purchaseButton.setAttributedTitle(attributedString, for: .normal)
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(purchaseView)
        view.addSubview(lessonView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            purchaseView.heightAnchor.constraint(equalToConstant: 510),
            purchaseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            purchaseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            purchaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            lessonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lessonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lessonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lessonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - Handle user events
    @objc
    private func cellTapped() {
//        guard purchaseView.isHidden else {
//            purchaseView.hide { _ in
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController?.tabBar.isTranslucent = false
//                self.purchaseView.isHidden = true
//            }
//            return
//        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let _ = tableView.cellForRow(at: tapIndexPath) as? LessonCell
            else { return }
        var model: Lesson?
        if tapIndexPath.row == 2, !models.isEmpty {
            model = models[0]
        } else if models.count >= tapIndexPath.row - 4 {
            model = models[tapIndexPath.row - 3]
        }
        //let vc = WebViewController()
        if let string = model?.file {
            //vc.urlString = string
            lessonView.urlString = string
            pan.isEnabled = false
        }
        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        present(vc, animated: true)
//        NetworkService.shared.updateInfo(courseId: courseId, values: model?.id ?? "") { result in
//            switch result {
//            case .success(let result):
//                guard let string = String(data: result, encoding: .utf8) else { return }
//                print(string)
//            case .failure(let error):
//                print("Error on clicking on lesson: \(error)")
//            }
//        }
    }
    
    @objc
    private func viewDragged() {
        switch pan.state {
        case .changed:
            handlePanChangedState()
        case .ended:
            handlePanEndedState()
        default:
            break
        }
    }
}

//MARK: - UnlockDelegate
extension CourseViewController: UnlockDelegate {
    func unlock() {
//        if !purchaseView.isHidden {
//            purchaseView.hide { _ in
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController?.tabBar.isTranslucent = false
//                self.purchaseView.isHidden = true
//            }
//        } else {
//            purchaseView.show()
//        }
        
        self.purchase()
    }
}

//MARK: - PurchaseViewDelegate
extension CourseViewController: PurchaseViewDelegate {
    func close() {
        purchaseView.isHidden = true
    }
}

//MARK: - WebDelegate
extension CourseViewController: WebDelegate {
    func enablePanGestureRecognizer() {
        pan.isEnabled = true
    }
}

//MARK: - Purchasing
extension CourseViewController {
    private func purchase() {
        SwiftyStoreKit.purchaseProduct("FirstInArchitectureCourseTest", quantity: 1, atomically: true) { result in
            switch result {
            case .success(purchase: let purchase):
                self.purchaseView.isHidden = false
                self.coursePurchased = true
                print(purchase)
                self.verifyPurchase()
            case .error(error: let error):
                print(error)
            }
        }
    }
    
    private func verifyPurchase() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "999")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                let productId = "FirstInArchitectureCourseTest"
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Verify receipt failed: \(error)")
            }
        }
    }

}

//MARK: - IntroDelegate
extension CourseViewController: IntroDelegate {
    func showIntro() {
//        let vc = WebViewController()
//        vc.urlString = models[0].file
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .coverVertical
//        present(vc, animated: true)
        lessonView.urlString = models[0].file
        pan.isEnabled = false
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 242
        case 1:
            return calculateDescriptionHeight()
        case 2:
            let screenWidth = UIScreen.main.bounds.width
            let buttonHeight = (screenWidth - (2 * IntroButton.spacing.rawValue)) * IntroButton.getHeightOnWidthRatio()
            return buttonHeight + 50
        case 3:
            let mainViewWidth = UIScreen.main.bounds.width - UnlockButton.spacing.rawValue * 2
            let mainViewHeight = mainViewWidth * UnlockButton.getHeightOnWidthRatio()
            //let mainViewTotalHeight = mainViewHeight + (UnlockButton.getVerticalShadow() * mainViewHeight)
            return mainViewHeight + 80
        default:
            switch models[indexPath.row - 3].category {
            case "2":
                return 140
            case "3", "4":
                return 80
            default:
                return 140
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = coursePurchased ? models.count + 1 : models.count + 3
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if coursePurchased {
            return configurePurchasedCourse(tableView, cellForRowAt: indexPath)
        } else {
            return configureNotPurchasedCourse(tableView, cellForRowAt: indexPath)
        }
    }
    
    private func configurePurchasedCourse(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return configureCourseTitleCell()
        case 1:
            return configureDescription()
        default:
            if models.count > indexPath.row - 2 {
                let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                let model = models[indexPath.row - 1]
                cell.configure(withDataSource: model)
                cell.unlock()
                if model.idType == "2" {
                    cell.setImage(imageString: model.img ?? "")
                }
                return cell
            }
            return UITableViewCell()
        }
    }
    
    private func configureNotPurchasedCourse(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return configureCourseTitleCell()
        case 1:
            return configureDescription()
        case 3:
            return configureUnlock()
        default:
            if indexPath.row == 2, !models.isEmpty {
                let cell: IntroCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(withDelegate: self)
                return cell
            } else if models.count > indexPath.row - 4 {
                let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                let model = models[indexPath.row - 3]
                cell.configure(withDataSource: model)
                if indexPath.row >= 4 { cell.lock() }
                if model.idType == "2" {
                    cell.setImage(imageString: model.img ?? "")
                }
                return cell
            }
            return UITableViewCell()
        }
    }
    
    private func configureCourseTitleCell() -> CourseTitleCell {
        let cell: CourseTitleCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 0, section: 0))
        cell.configure(withTitle: courseTitle, imageUrl: courseImageUrl)
        return cell
    }
    
    private func configureDescription() -> DescriptionCell {
        let cell: DescriptionCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 1, section: 0))
        cell.configure(withText: descriptionText)
        return cell
    }
    
    private func configureUnlock() -> UnlockCell {
        let cell: UnlockCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 3, section: 0))
        cell.configure(withDelegate: self)
        return cell
    }
    
    private func calculateDescriptionHeight() -> CGFloat {
        let string = descriptionText
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let height = string.height(width: UIScreen.main.bounds.width - 20, font: font)
        return height + 4
    }
}
