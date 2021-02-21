//
//  AchievementViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 21.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController {

    var achievementView: AchievementView? {
        didSet {
            setupAchievementView()
        }
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        achievementView?.roundImageView()
    }
    
    private func setupAchievementView() {
        guard let achievementView = self.achievementView else { return }
        achievementView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(achievementView)
        
        NSLayoutConstraint.activate([
            achievementView.topAnchor.constraint(equalTo: view.topAnchor),
            achievementView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            achievementView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achievementView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}
