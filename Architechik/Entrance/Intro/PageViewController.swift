//
//  PageViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 20.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let subViews = view.subviews
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil
        
        for view in subViews {
            if view is UIScrollView {
                scrollView = view as? UIScrollView
            }
            else if view is UIPageControl {
                pageControl = view as? UIPageControl
            }
        }
        
        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubviewToFront(pageControl!)
        }
    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.backgroundColor = .black
        dataSource = self
        delegate = self
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor(hex: "222222")
        appearance.currentPageIndicatorTintColor = UIColor.white
        let vc0 = HelloViewController()
        vc0.modalPresentationStyle = .fullScreen
        //vc0.index = 0
//        let vc1 = AppDescriptionViewController()
//        vc1.index = 1
//        let vc2 = FeaturesViewController()
//        vc2.index = 2
//        let vc3 = LoginViewController()
//        vc3.index = 3
        setViewControllers([vc0], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupSubviews() {
        
    }
    
}

//MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is HelloViewController {
            return nil
        }
        if viewController is AppDescriptionViewController {
            self.currentIndex = 0
            return HelloViewController()
        }
        if viewController is FeaturesViewController {
            self.currentIndex = 1
            return AppDescriptionViewController()
        }
        if viewController is LoginViewController {
            self.currentIndex = 2
            return FeaturesViewController()
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is HelloViewController {
            self.currentIndex = 1
            return AppDescriptionViewController()
        }
        if viewController is AppDescriptionViewController {
            self.currentIndex = 2
            return FeaturesViewController()
        }
        if viewController is FeaturesViewController {
            self.currentIndex = 3
            return LoginViewController()
        }
        if viewController is LoginViewController {
            return nil
        }
        return nil
    }
    
    
}
