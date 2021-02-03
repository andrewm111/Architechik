//
//  FilterView.swift
//  Architechik
//
//  Created by Александр Цветков on 18.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class FilterView: UIView, CardViewProtocol {

    private lazy var stackView: UIStackView = {
        var views: Array<UIView> = []
        let categoryAllView = CategoryView(ofType: Category.init(rawValue: -1), categoryName: categoryName)
        categoryAllView.select()
        views.append(categoryAllView)
        for i in 1...3 {
            let categoryView = CategoryView(ofType: Category.init(rawValue: i), categoryName: categoryName)
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
    
    //MARK: - Properties
    private var categoryName: String = ""
    var height: CGFloat = 280
    
    //MARK: - View lifecycle
    convenience init(withCategoryName categoryName: String) {
        self.init(frame: .zero)
        self.categoryName = categoryName
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
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
        ])
    }
}

protocol CardViewProtocol: UIView {
    var height: CGFloat { get set }
}

extension CardViewProtocol {
    func show(completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: -self.height)
            }, completion: completion)
        }
    }
    
    func hide(completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
}
