//
//  AchievementCell.swift
//  Architechik
//
//  Created by Александр Цветков on 10.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class AchievementCell: TableViewCell {
    
    //MARK: - Subviews
    private let achievementImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 40
        view.backgroundColor = UIColor(hex: "613191")
        view.image = UIImage(named: "bumagaFull")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial-BoldMT", size: 17)
        view.textColor = UIColor(hex: "613191")
        view.text = "How to tell about your project"
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Arial", size: 16)
        view.numberOfLines = 0
        view.textColor = UIColor(hex: "613191")
        view.text = "Ты получил ачивку.Ты получил ачивку.Ты получил ачивку.Ты получил ачивку.Ты получил ачивку."
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "222222")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let shareButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "share"), for: .normal)
        view.tintColor = UIColor(hex: "613191")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var delegate: SharingDelegate?

    func configure(withDelegate delegate: SharingDelegate) {
        self.delegate = delegate
        selectionStyle = .none
        backgroundColor = .clear
        initialSetup()
        setupSubviews()
    }
    
    private func initialSetup() {
        isUserInteractionEnabled = true
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }

    private func setupSubviews() {
        addSubview(achievementImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(separatorView)
        addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            achievementImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            achievementImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            achievementImageView.heightAnchor.constraint(equalToConstant: 80),
            achievementImageView.widthAnchor.constraint(equalToConstant: 80),
            
            shareButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 20),
            shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            titleLabel.topAnchor.constraint(equalTo: achievementImageView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -4),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: achievementImageView.trailingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
    @objc
    private func shareTapped() {
        // Setting description
        let firstActivityItem = "Я получил достижение в Architechik"

        // Setting url
        //let secondActivityItem: NSURL = NSURL(string: "http://google.com/")!

        // If you want to use an image
        let image: UIImage = UIImage(named: "bumagaFull")!
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, image], applicationActivities: nil)

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = shareButton

        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading

        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]

        activityViewController.isModalInPresentation = true
        delegate?.share(with: activityViewController)
    }
}

protocol SharingDelegate {
    func share(with activityVC: UIActivityViewController)
}
