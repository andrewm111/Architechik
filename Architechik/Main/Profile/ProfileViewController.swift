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
    private var progressView: ProgressView?
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    var models: Array<Achievement> = [] {
        willSet {
            if !newValue.isEmpty { activityIndicatorView.stopAnimating() }
        }
        didSet {
            checkAchievements()
        }
    }
    var studentAchievements: Array<Achievement> = [] {
        willSet {
            if !newValue.isEmpty { activityIndicatorView.stopAnimating() }
        }
        didSet {
            if !studentAchievements.isEmpty {
                activityIndicatorView.stopAnimating()
                tableView.reloadData()
            }
        }
    }
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    var bottomPadding: CGFloat = {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets.bottom
    }()
    lazy var achievementHeight: CGFloat = {
        let padding: CGFloat = 0
        let height: CGFloat = (UIScreen.main.bounds.height * 0.312807881773399) + self.bottomPadding + padding
        return height
    }()
    private let achievementVC: AchievementViewController = {
        let vc = AchievementViewController()
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }()
    private var achievementIsHidden = true
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        achievementVC.achievementView = AchievementView(withModel: nil, delegate: self)
        view.backgroundColor = .black
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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
        view.addSubview(activityIndicatorView)
        
        if studentAchievements.isEmpty { activityIndicatorView.startAnimating() }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    //MARK: - Supporting methods
    private func setTotalProgress() {
        var totalProgress: CGFloat = 0
        _ = studentAchievements.map { achievement in
            totalProgress += achievement.progress ?? 0
        }
        guard NetworkDataFetcher.shared.courses.count != 0 else { return }
        progressView?.progress = totalProgress / CGFloat(NetworkDataFetcher.shared.courses.count)
    }
    
    private func checkAchievements() {
        var array: Array<Achievement> = []
        for courseProgress in NetworkDataFetcher.shared.studentProgress {
            if var achievement = models.filter({ $0.idCourses == courseProgress.idCourses }).first  {
                let stringProgress = courseProgress.currentProgress.dropFirst().filter( { "1".contains($0) } )
                let currentProgress = CGFloat(stringProgress.count)
                guard let courseIndex = NetworkDataFetcher.shared.courses.firstIndex(where: { $0.id == courseProgress.idCourses }) else { return }
                let courseNumber = NetworkDataFetcher.shared.courses[courseIndex].courseNumber
                guard let courseNumberInt = Int(courseNumber) else { return }
                achievement.progress = currentProgress / (CGFloat(courseNumberInt) - 1)
                array.append(achievement)
            }
        }
        studentAchievements = array
    }
    
    //MARK: - Handle user events
    @objc
    private func cellTapped() {
        guard achievementIsHidden else {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.2) {
                self.achievementVC.view.frame = CGRect(x: 0, y: height, width: width, height: self.achievementHeight)
            } completion: { _ in
                self.tableView.isScrollEnabled = true
                self.achievementIsHidden = true
                self.achievementVC.willMove(toParent: nil)
                self.achievementVC.view.removeFromSuperview()
                self.achievementVC.removeFromParent()
            }
            return
        }
        let tapLocation = tap.location(in: tableView)
        guard
            let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation),
            let cell = tableView.cellForRow(at: tapIndexPath) as? AchievementCell
            else { return }
        achievementVC.achievementView?.configure(withModel: studentAchievements[tapIndexPath.row - 1], image: cell.getImage())
        self.tableView.isScrollEnabled = false
        self.tabBarController?.addChild(achievementVC)
        self.tabBarController?.view.addSubview(achievementVC.view)
        achievementVC.didMove(toParent: self.tabBarController)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        self.achievementVC.view.frame = CGRect(x: 0, y: height, width: width, height: 254 + self.bottomPadding)
        UIView.animate(withDuration: 0.2) {
            self.achievementVC.view.frame = CGRect(x: 0, y: height - (self.achievementHeight), width: width, height: self.achievementHeight)
        } completion: { _ in
            self.achievementIsHidden = false
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
        self.presentActivityVC(image: image, text: text)
    }
    
    private func presentActivityVC(image: UIImage?, text: String) {
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
        activityViewController.popoverPresentationController?.sourceView = achievementVC.achievementView
        
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
        present(activityViewController, animated: true) {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.2) {
                self.achievementVC.view.frame = CGRect(x: 0, y: height, width: width, height: 254 + self.bottomPadding)
            } completion: { _ in
                self.tableView.isScrollEnabled = true
                self.achievementIsHidden = true
                self.achievementVC.willMove(toParent: nil)
                self.achievementVC.view.removeFromSuperview()
                self.achievementVC.removeFromParent()
            }
        }
    }
    
}
