//
//  CategoryView.swift
//  Architechik
//
//  Created by Александр Цветков on 18.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class CategoryView: UIView {

    //MARK: - Subviews
//    private let checkmarkIcon: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "checkmark")
//        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    private let label: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 17)
        view.textColor = .white
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    private var category: Category = .intermediate
    private var categoryName: String = ""
    
    //MARK: - View lifecycle
    convenience init(ofType type: Category?, categoryName: String) {
        self.init(frame: .zero)
        self.categoryName = categoryName
        setupSubviews()
        if let type = type { self.category = type }
        initialSetup(withType: category, categoryName: categoryName)
    }
    
    //MARK: - Setup
    private func initialSetup(withType type: Category, categoryName: String) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        
        layer.cornerRadius = 16
        let tap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        //let name = categoryName == "grammar" ? categoryName : categoryName + "s"
        switch type {
        case .all:
            label.text = "All"
        case .elementary:
            label.text = "Elementary"
        case .intermediate:
            label.text = "Intermediate"
        case .advance:
            label.text = "Advanced"
        }
    }
    
    private func setupSubviews() {
        //addSubview(checkmarkIcon)
        addSubview(label)
        
//        checkmarkIcon.heightAnchor.constraint(equalToConstant: 14),
//        checkmarkIcon.widthAnchor.constraint(equalToConstant: 14),
//        checkmarkIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//        checkmarkIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 4),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -4),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    //MARK: - External methods
    func select() {
        //checkmarkIcon.isHidden = false
        label.textColor = .black
        self.backgroundColor = UIColor(hex: "613191")
    }
    
    private func unselect() {
        //checkmarkIcon.isHidden = true
        label.textColor = .white
        self.backgroundColor = .black
    }

    @objc
    private func categoryTapped() {
        let info: [String: Any] = ["category": category.rawValue, "categoryName": categoryName]
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: info)
        select()
    }
    
    @objc private func categoryChanged(_ notification: Notification) {
        guard
            let categoryInfo = notification.userInfo?["category"] as? Int,
            let name = notification.userInfo?["categoryName"] as? String,
            name == categoryName
            else { return }
        if categoryInfo == category.rawValue { select() } else { unselect() }
    }
}

enum Category: Int {
    case all = -1
    case elementary = 1
    case intermediate = 2
    case advance = 3
}
