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
    
    //MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //        let coursesVC: UINavigationController = generateViewController(vcType: UINavigationController.self, title: "Courses", imageName: "menuIcon")
        //        coursesVC.navigationBar.isHidden = true
        //        coursesVC.viewControllers = [CoursesViewController()]
        let coursesVC = generateViewController(vcType: ListCourseViewController.self, title: "Courses", imageName: "courses")
        let coursesCD = DataManager.shared.fetchAllCourses()
        var courses: Array<Course> = []
        _ = coursesCD.map { courseCD in
            courses.append(Course(fromModel: courseCD))
        }
        coursesVC.models = courses
        NetworkDataFetcher.shared.fetchCourses { courses in
            coursesVC.models = courses
            DataManager.shared.saveCourses(courses)
            NetworkDataFetcher.shared.fetchCourseStructure { lessons in
                coursesVC.lessons = lessons
                DataManager.shared.saveLessons(lessons)
            }
        }
        let articlesVC = generateViewController(vcType: ArticlesViewController.self, title: "Articles", imageName: "articles")
        let articlesCD = DataManager.shared.fetchAllArticles()
        var articles: Array<Article> = []
        _ = articlesCD.map { articleCD in
            articles.append(Article(fromModel: articleCD))
        }
        articlesVC.models = articles
        NetworkDataFetcher.shared.fetchArticles { articles in
            articlesVC.models = articles
            DataManager.shared.saveArticles(articles)
        }
        let grammarVC = generateViewController(vcType: GrammarViewController.self, title: "Grammar", imageName: "grammar")
        let grammarsCD = DataManager.shared.fetchAllGrammar()
        var grammars: Array<Grammar> = []
        _ = grammarsCD.map { grammarCD in
            grammars.append(Grammar(fromModel: grammarCD))
        }
        grammarVC.models = grammars
        NetworkDataFetcher.shared.fetchGrammar { grammar in
            grammarVC.models = grammar
            DataManager.shared.saveGrammar(grammar)
        }
        let profileVC = generateViewController(vcType: ProfileViewController.self, title: "Profile", imageName: "achievements")
        let achievementsCD = DataManager.shared.fetchAllAchievements()
        var achievements: Array<Achievement> = []
        _ = achievementsCD.map { achievementCD in
            achievements.append(Achievement(fromModel: achievementCD))
        }
        profileVC.models = achievements
        NetworkDataFetcher.shared.fetchAchievments { achievements in
            profileVC.models = achievements
            DataManager.shared.saveAchievements(achievements)
        }
        setViewControllers([coursesVC, articlesVC, grammarVC, profileVC], animated: false)
        selectedViewController = coursesVC
        tabBar.tintColor = UIColor(hex: "613191")
        tabBar.unselectedItemTintColor = UIColor.white
        //tabBar.barTintColor = UIColor(hex: "1F1F24")
        tabBar.barTintColor = UIColor.black
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
