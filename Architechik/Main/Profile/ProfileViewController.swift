//
//  ProfileViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class ProfileViewController: ViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var achievementView: AchievementView = {
        let view = AchievementView(withModel: nil, delegate: self)
        view.height = 250
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var progressView: ProgressView?
    
    //MARK: - Properties
    var models: Array<Achievement> = [] {
        didSet {
            checkAchievements()
        }
    }
    var studentAchievements: Array<Achievement> = [] {
        didSet {
            if models.count != 0 { tableView.reloadData() }
        }
    }
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        achievementView.roundImageView()
        setTotalProgress()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAchievements()
        setTotalProgress()
        tableView.reloadData()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.backgroundColor = .black
        //view.backgroundColor = UIColor(hex: "1F1F24")
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileHeaderCell.self)
        tableView.register(AchievementCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addTabBarSeparator()
        view.addSubview(tableView)
        view.addSubview(achievementView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            achievementView.heightAnchor.constraint(equalToConstant: 310),
            achievementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 360),
            achievementView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achievementView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - Supporting methods
    private func setTotalProgress() {
        var totalProgress: CGFloat = 0
        _ = studentAchievements.map { achievement in
            totalProgress += achievement.progress ?? 0
        }
        progressView?.progress = totalProgress / CGFloat(NetworkDataFetcher.shared.courses.count)
    }
    
    private func checkAchievements() {
        studentAchievements = []
        for courseProgress in NetworkDataFetcher.shared.studentProgress {
            if courseProgress.currentProgress.contains("1"), var achievement = models.filter({ $0.idCourses == courseProgress.idCourses }).first  {
                let stringProgress = courseProgress.currentProgress.dropFirst().filter( { "1".contains($0) } )
                let currentProgress = CGFloat(stringProgress.count)
                guard let courseIndex = NetworkDataFetcher.shared.courses.firstIndex(where: { $0.id == courseProgress.idCourses }) else { return }
                let courseNumber = NetworkDataFetcher.shared.courses[courseIndex].courseNumber
                guard let courseNumberInt = Int(courseNumber) else { return }
                achievement.progress = currentProgress / (CGFloat(courseNumberInt) - 1)
                studentAchievements.append(achievement)
            }
        }
    }
    
    //MARK: - Handle user events
    @objc
    private func cellTapped() {
        guard achievementView.isHidden else {
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.tabBar.isTranslucent = false
            achievementView.hide { _ in
                self.tableView.isScrollEnabled = true
                self.achievementView.isHidden = true
                //                self.tabBarController?.tabBar.isHidden = false
                //                self.tabBarController?.tabBar.isTranslucent = false
            }
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let cell = tableView.cellForRow(at: tapIndexPath) as? AchievementCell
            else { return }
        achievementView.configure(withModel: models[tapIndexPath.row - 1], image: cell.getImage())
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.isScrollEnabled = false
        achievementView.show { _ in
            
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 230
        default:
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentAchievements.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: ProfileHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(withProgress: 0.75)
            progressView = cell.progressView
            return cell
        default:
            let cell: AchievementCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if studentAchievements.count >= indexPath.row {
                let model = studentAchievements[indexPath.row - 1]
                cell.configure(withModel: model)
            }
            return cell
        }
    }
}

//MARK: - SharingDelegate
extension ProfileViewController: SharingDelegate {
    
    func shareTapped(image: UIImage?, text: String) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        achievementView.hide { _ in
            self.tableView.isScrollEnabled = true
            self.achievementView.isHidden = true
            //                self.tabBarController?.tabBar.isHidden = false
            //                self.tabBarController?.tabBar.isTranslucent = false
        }
        // Setting description
        let firstActivityItem = text
        
        // Setting url
        //let secondActivityItem: NSURL = NSURL(string: "http://google.com/")!
        
        // If you want to use an image
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
