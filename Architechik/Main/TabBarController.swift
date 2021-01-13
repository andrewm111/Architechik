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
        
//        let coursesVC: UINavigationController = generateViewController(vcType: UINavigationController.self, title: "Courses", imageName: "menuIcon")
//        coursesVC.navigationBar.isHidden = true
//        coursesVC.viewControllers = [CoursesViewController()]
        let coursesVC = generateViewController(vcType: CoursesViewController.self, title: "Courses", imageName: "courses")
        let articlesVC = generateViewController(vcType: ArticlesViewController.self, title: "Articles", imageName: "articles")
        let grammarVC = generateViewController(vcType: GrammarViewController.self, title: "Grammar", imageName: "grammar")
        let profileVC = generateViewController(vcType: ProfileViewController.self, title: "Profile", imageName: "achievements")
        setViewControllers([coursesVC, articlesVC, grammarVC, profileVC], animated: false)
        selectedViewController = coursesVC
        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.barTintColor = UIColor(hex: "1F1F24")
        tabBar.isTranslucent = false
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
        let image = UIImage(named: "\(imageName)Gray")
        let selectedImage = UIImage(named: imageName)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        //tabBarItem.titlePositionAdjustment
        let font = UIFont(name: "Arial", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let attributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        let attributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        tabBarItem.setTitleTextAttributes(attributesNormal, for: .normal)
        tabBarItem.setTitleTextAttributes(attributesSelected, for: .selected)
        vc.tabBarItem = tabBarItem
        return vc
    }

}
