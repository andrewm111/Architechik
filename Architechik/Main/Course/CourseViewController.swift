//
//  CourseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import StoreKit

class CourseViewController: ViewController {
    
    //MARK: - Subviews
    private let imageView: UIImageView = {
        let view = UIImageView()
        //view.backgroundColor = UIColor(hex: "1F1F24")
        view.image = UIImage(named: "backImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 22)
        view.textColor = .white
        view.text = "History of architecture"
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Properties
    lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(viewDragged))
    var products: Array<SKProduct> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        view.backgroundColor = UIColor.black
        getProducts()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self)
        tableView.register(DescriptionCell.self)
        tableView.register(UnlockCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        view.addGestureRecognizer(pan)
    }
    
    private func getProducts() {
        
    }

    private func setupSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 30),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: titleView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: titleView.bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 14),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - Handle user events
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
        let vc = PurchaseViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.product = products.first
        view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
        //present(vc, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return calculateDescriptionHeight()
        case 4:
            return 60
        default:
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return configureDescription()
        case 4:
            return configureUnlock()
        default:
            let cell: LessonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let article = Article(id: "", title: "", description: "", img: "", file: "")
            cell.configure(withDataSource: article)
            return cell
        }
    }
    
    private func configureDescription() -> DescriptionCell {
        let cell: DescriptionCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 0, section: 0))
        cell.configure()
        return cell
    }
    
    private func configureUnlock() -> UnlockCell {
        let cell: UnlockCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: 4, section: 0))
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
