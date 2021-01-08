//
//  TabBarController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    //MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let coursesVC = generateViewController(vcType: CoursesViewController.self, title: "Courses", imageName: "menuIcon")
        let articlesVC = generateViewController(vcType: ArticlesViewController.self, title: "Articles", imageName: "menuIcon")
        let grammarVC = generateViewController(vcType: GrammarViewController.self, title: "Grammar", imageName: "menuIcon")
        let profileVC = generateViewController(vcType: ProfileViewController.self, title: "Profile", imageName: "menuIcon")
        setViewControllers([coursesVC, articlesVC, grammarVC, profileVC], animated: false)
        selectedViewController = coursesVC
        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.barTintColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Supporting methods
    private func generateViewController<T: UIViewController>(vcType: T.Type, title: String, imageName: String) -> T {
        let vc = T()
        let image = UIImage(named: imageName)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        let font = UIFont(name: "Arial", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let attributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        let attributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        tabBarItem.setTitleTextAttributes(attributesNormal, for: .normal)
        tabBarItem.setTitleTextAttributes(attributesSelected, for: .selected)
        vc.tabBarItem = tabBarItem
        return vc
    }

}
