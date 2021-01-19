//
//  FilterView.swift
//  Architechik
//
//  Created by Александр Цветков on 18.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    private lazy var stackView: UIStackView = {
        var views: Array<UIView> = []
        for i in -1...2 {
            let categoryView = CategoryView(ofType: Category.init(rawValue: i))
            views.append(categoryView)
        }
        let view = UIStackView(arrangedSubviews: views)
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - View lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        backgroundColor = UIColor(hex: "1F1F24")
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
        ])
    }
    
}
