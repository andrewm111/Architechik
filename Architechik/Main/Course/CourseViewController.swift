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

class CourseViewController: ViewController {
    
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
    
    //MARK: - Properties
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(viewDragged))
    var product: SKProduct?
    var helper: IAPHelper = IAPHelper(productIds: ["FirstInArchitectureCourseTest"])

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
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
        guard
        let product = product,
        let price = product.localizedPrice
        else { return }
        let attributedString = NSAttributedString(string: product.localizedTitle + " за " + price, attributes: purchaseView.attributes)
        purchaseView.purchaseButton.setAttributedTitle(attributedString, for: .normal)
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(purchaseView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            purchaseView.heightAnchor.constraint(equalToConstant: 180),
            purchaseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            purchaseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            purchaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - Handle user events
    @objc
    private func cellTapped() {
        guard purchaseView.isHidden else {
            purchaseView.isHidden = true
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let _ = tableView.cellForRow(at: tapIndexPath) as? CourseCell
            else { return }
        
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
    
    //MARK: - Handle swipe to dismiss gesture
    private func handlePanChangedState() {
        let translationX = pan.translation(in: view).x
        guard translationX > 0 else { return }
        guard translationX < UIScreen.main.bounds.width / 3 else {
            pan.isEnabled = false
            animateDismiss()
            return
        }
        view.transform = CGAffineTransform(translationX: translationX, y: 0)
    }
    
    private func handlePanEndedState() {
        let translationX = pan.translation(in: view).x
        if translationX > UIScreen.main.bounds.width * 0.22 {
            animateDismiss()
        } else {
            animateReturnToNormalState()
        }
    }
    
    private func animateDismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        }) { _ in
            self.pan.isEnabled = true
            self.dismiss(animated: false)
        }
    }
    
    private func animateReturnToNormalState() {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = .identity
        }
    }
}

//MARK: - UnlockDelegate
extension CourseViewController: UnlockDelegate {
    func unlock() {
        purchaseView.isHidden = false
    }
}

//MARK: - PurchaseDelegate
extension CourseViewController: PurchaseDelegate {
    func purchase() {
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 244
        case 1:
            return calculateDescriptionHeight()
        case 3:
            return 75
        default:
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return configureCourseTitleCell()
        case 1:
            return configureDescription()
        case 3:
            return configureUnlock()
        default:
            let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let article = Article(id: "", title: "", description: "", img: "", file: "")
            cell.configure(withDataSource: article)
            if indexPath.row >= 4 { cell.lock() }
            return cell
        }
    }
    
    private func configureCourseTitleCell() -> CourseTitleCell {
        let cell: CourseTitleCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 0, section: 0))
        cell.configure(withTitle: "", image: UIImage())
        return cell
    }
    
    private func configureDescription() -> DescriptionCell {
        let cell: DescriptionCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 1, section: 0))
        cell.configure()
        return cell
    }
    
    private func configureUnlock() -> UnlockCell {
        let cell: UnlockCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 3, section: 0))
        cell.configure(withDelegate: self)
        return cell
    }
    
    private func calculateDescriptionHeight() -> CGFloat {
        let string = "Этот курс - большой сборник архитектурных терминов и упражнений, чтобы легко ориентироваться в англоязычных текстах про любой стиль и эпоху."
        let font = UIFont(name: "Arial", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let height = string.height(width: UIScreen.main.bounds.width - 20, font: font)
        return height
    }
}
