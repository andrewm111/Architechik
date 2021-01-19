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
    private let checkmarkIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "checkmark")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let label: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 17)
        view.textColor = .white
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    private var category: Category = .intermediate
    
    //MARK: - View lifecycle
    convenience init(ofType type: Category?) {
        self.init(frame: .zero)
        setupSubviews()
        if let type = type { self.category = type }
        initialSetup(withType: category)
    }
    
    //MARK: - Setup
    private func initialSetup(withType type: Category) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        
        layer.cornerRadius = 16
        let tap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: NSNotification.Name("CategoryChanged"), object: nil)
        switch type {
        case .all:
            label.text = "All"
        case .elementary:
            label.text = "Elementary"
        case .intermediate:
            label.text = "Intermediate"
        case .advance:
            label.text = "Advance"
        }
    }
    
    private func setupSubviews() {
        addSubview(checkmarkIcon)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 150),
            
            checkmarkIcon.heightAnchor.constraint(equalToConstant: 14),
            checkmarkIcon.widthAnchor.constraint(equalToConstant: 14),
            checkmarkIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkmarkIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: checkmarkIcon.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    //MARK: - External methods
    private func select() {
        checkmarkIcon.isHidden = false
        label.textColor = .blue
    }
    
    private func unselect() {
        checkmarkIcon.isHidden = true
        label.textColor = .white
    }

    @objc
    private func categoryTapped() {
        let info = ["category": category.rawValue]
        NotificationCenter.default.post(name: NSNotification.Name("CategoryChanged"), object: nil, userInfo: info)
        select()
    }
    
    @objc private func categoryChanged(_ notification: Notification) {
        guard let categoryInfo = notification.userInfo?["category"] as? Int else { return }
        if Int(categoryInfo) == category.rawValue { select() } else { unselect() }
    }
}

enum Category: Int {
    case all = -1
    case elementary = 0
    case intermediate = 1
    case advance = 2
}
