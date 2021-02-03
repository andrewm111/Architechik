//
//  ProfileHeaderCell.swift
//  Architechik
//
//  Created by Александр Цветков on 25.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class ProfileHeaderCell: TableViewCell {
    
    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "avatar")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 75
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let progressLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 18)
        view.textColor = .white
        view.text = "Кол-во пройденных курсов"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tapLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hex: "613191")
        view.text = "Нажми на достижение чтобы поделиться"
        view.font = UIFont(name: "Arial", size: 18)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let progressView: ProgressView = {
        let view = ProgressView(withProgress: 0.75)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func configure(withProgress progress: Float) {
        //progressView.progress = progress
        initialSetup()
        setupSubviews()
    }

    //MARK: - Setup
    private func initialSetup() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupSubviews() {
        addSubview(avatarView)
        addSubview(progressLabel)
        addSubview(progressView)
        addSubview(tapLabel)
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: self.topAnchor),
            avatarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 150),
            avatarView.heightAnchor.constraint(equalToConstant: 150),
            
            progressLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            progressLabel.heightAnchor.constraint(equalToConstant: 24),
            progressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            progressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            tapLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),
            tapLabel.heightAnchor.constraint(equalToConstant: 24),
            tapLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            tapLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
        ])
    }
}
