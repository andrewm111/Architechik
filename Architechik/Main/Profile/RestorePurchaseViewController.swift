//
//  RestorePurchaseViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 03.03.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class RestorePurchaseViewController: ViewController {
    
    //MARK: - Subviews
    private(set) var idCourses: Array<String> = []
    
    //MARK: - Properties

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        
    }
    
    private func setupSubviews() {
        
    }
    
    //MARK: - Handle user events
    @objc
    private func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.showSimpleAlert(title: "Ошибка!", message: "Что-то пошло не так", actionTitle: "Ок")
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.handleRestoreProccess(results.restoredPurchases.map({ $0.productId }))
            } else {
                print("Nothing to Restore")
                self.showSimpleAlert(title: "Ой!", message: "Нечего восстанавливать", actionTitle: "Ок")
            }
        }
    }
    
    //MARK: - Supporting methods
    private func handleRestoreProccess(_ productIdentifiers: Array<String>) {
        let coursesToRestore = selectCoursesToRestore(withProductIdentifiers: productIdentifiers)
        let idCourses = selectIdOfCoursesNotPurchasedOnServer(coursesToRestore)
        self.idCourses = idCourses
        if !self.idCourses.isEmpty { buyAgain(index: 0) }
    }

    private func selectCoursesToRestore(withProductIdentifiers productIdentifiers: Array<String>) -> Array<Course> {
        let allCourses = NetworkDataFetcher.shared.courses
        let coursesToRestore = allCourses.compactMap { course -> Course? in
            for productId in productIdentifiers {
                if productId == course.idProduct { return course }
            }
            return nil
        }
        return coursesToRestore
    }
    
    private func selectIdOfCoursesNotPurchasedOnServer(_ courses: Array<Course>) -> Array<String> {
        var idCoursesToBuyAgain: Array<String> = []
        for course in courses {
            for progress in NetworkDataFetcher.shared.studentProgress {
                if progress.courseAccess == "0" && course.id == progress.idCourses {
                    idCoursesToBuyAgain.append(course.id)
                }
            }
        }
        return idCoursesToBuyAgain
    }
    
    private func buyAgain(index: Int) {
        NetworkService.shared.buyCourse(courseId: idCourses[index]) { result in
            if self.idCourses.count >= index + 2 { self.buyAgain(index: index + 1) }
        }
    }
}
