//
//  TabBarController.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController {
    
    lazy var coursesVC = generateViewController(vcType: ListCourseViewController.self, title: "Courses", imageName: "courses")
    lazy var articlesVC = generateViewController(vcType: ArticlesViewController.self, title: "Articles", imageName: "articles")
    lazy var grammarVC = generateViewController(vcType: GrammarViewController.self, title: "Grammar", imageName: "grammar")
    lazy var profileVC = generateViewController(vcType: ProfileViewController.self, title: "Profile", imageName: "achievements")
    
    //MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        fetchData()
        NetworkDataFetcher.shared.checkUserInDatabase { studentProgress in
            
        }
        setViewControllers([coursesVC, articlesVC, grammarVC, profileVC], animated: false)
        selectedViewController = coursesVC
        configureTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Supporting methods
    private func configureTabBar() {
        tabBar.tintColor = UIColor(hex: "613191")
        tabBar.unselectedItemTintColor = UIColor.white
        //tabBar.barTintColor = UIColor(hex: "1F1F24")
        tabBar.barTintColor = UIColor.black
        tabBar.isTranslucent = false
    }
    
    private func generateViewController<T: UIViewController>(vcType: T.Type, title: String, imageName: String) -> T {
        let vc = T()
        let image = UIImage(named: imageName)
        let unselectedImage = image?.withTintColor(UIColor.white)
        let selectedImage = image?.withTintColor(UIColor(hex: "613191"))
        let tabBarItem = UITabBarItem(title: title, image: unselectedImage, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        let verticalOffset: CGFloat = smallScreen ? 3 : 5
        let fontSize: CGFloat = smallScreen ? 12 : 13
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
        let font = UIFont(name: "Arial", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        let attributesSelected = [NSAttributedString.Key.foregroundColor: UIColor(hex: "613191"), NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        tabBarItem.setTitleTextAttributes(attributesNormal, for: .normal)
        tabBarItem.setTitleTextAttributes(attributesSelected, for: .selected)
        vc.tabBarItem = tabBarItem
        return vc
    }
}
