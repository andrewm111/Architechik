//
//  UnlockCell.swift
//  Architechik
//
//  Created by Александр Цветков on 18.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class UnlockCell: TableViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(hex: "613191")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        let font = UIFont(name: "Arial-BoldMT", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "Разблокировать", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        view.attributedText = attributedString
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let unlockIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "unlock")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var delegate: UnlockDelegate?

    func configure(withDelegate delegate: UnlockDelegate) {
        self.delegate = delegate
        selectionStyle = .none
        backgroundColor = .clear
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(unlockTapped))
        mainView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addSubview(mainView)
        mainView.addSubview(unlockIcon)
        mainView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainView.widthAnchor.constraint(equalToConstant: 220),
            mainView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            unlockIcon.heightAnchor.constraint(equalToConstant: 25),
            unlockIcon.widthAnchor.constraint(equalToConstant: 25),
            unlockIcon.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            unlockIcon.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 14),
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: mainView.topAnchor, constant: 2),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -2),
            titleLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: unlockIcon.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainView.trailingAnchor, constant: -14),
        ])
    }
    
    @objc
    private func unlockTapped() {
        delegate?.unlock()
    }
}

protocol UnlockDelegate {
    func unlock()
}
