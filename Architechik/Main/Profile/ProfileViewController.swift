//
//  ProfileViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var achievementView: AchievementView = {
        let view = AchievementView(withModel: nil, delegate: self)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }

    //MARK: - Setup
    private func initialSetup() {
        //view.backgroundColor = UIColor(hex: "1F1F24")
        view.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileHeaderCell.self)
        tableView.register(AchievementCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
        
        tableView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        view.addSubview(achievementView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            achievementView.heightAnchor.constraint(equalToConstant: 200),
            achievementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            achievementView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achievementView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc
    private func cellTapped() {
        if achievementView.isHidden == false {
            achievementView.isHidden = true
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let _ = tableView.cellForRow(at: tapIndexPath)
            else { return }
        if tapIndexPath.row != 0 {
            achievementView.isHidden = false
        }
    }
    
    private func share() {
        // Setting description
        let firstActivityItem = "Я получил достижение в Architechik"

        // Setting url
        //let secondActivityItem: NSURL = NSURL(string: "http://google.com/")!

        // If you want to use an image
        let image = UIImage(named: "bumagaFull")
        var items: Array<Any> = [firstActivityItem]
        if let image = image { items.append(image) }
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: items, applicationActivities: nil)

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = achievementView

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
        present(activityViewController, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 208
        default:
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: ProfileHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(withProgress: 0.75)
            return cell
        default:
            let cell: AchievementCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(withModel: Achievement(id: "", title: "", description: "", idCourses: "", imgGood: "", imgBad: ""))
            return cell
        }
    }
}

//MARK: - SharingDelegate
extension ProfileViewController: SharingDelegate {
    
    func shareTapped() {
        self.share()
    }
    
}
