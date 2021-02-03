//
//  CourseTitleCell.swift
//  Architechik
//
//  Created by Александр Цветков on 25.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class CourseTitleCell: TableViewCell {
    
    private let titleImageView: WebImageView = {
        let view = WebImageView()
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

    func configure(withTitle courseTitle: String, imageUrl: String) {
        if imageUrl != "" {
            titleImageView.set(imageURL: imageUrl)
        }
        if courseTitle != "" {
            titleLabel.text = courseTitle
        }
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupSubviews() {
        addSubview(titleImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: 200),
            titleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
}
