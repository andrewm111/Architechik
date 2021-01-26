//
//  CourseTitleCell.swift
//  Architechik
//
//  Created by Александр Цветков on 25.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class CourseTitleCell: TableViewCell {
    
    private let titleImageView: UIImageView = {
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
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func configure(withTitle: String, image: UIImage) {
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
            
            titleLabel.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 2),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
}
