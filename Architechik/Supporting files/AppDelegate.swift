//
//  AppDelegate.swift
//  Architechik
//
//  Created by Александр Цветков on 02.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import CoreData
import AuthenticationServices
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Persistent container error: \(error)")
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        //self.window?.rootViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        //self.window?.rootViewController = LoginViewController()
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
            print(payment)
            print(product)
            // return true if the content can be delivered by your app
            // return false otherwise
            return true
        }
        //checkNetworkService()
        addTransactionObserver()
        //loginUser()
        
        return true
    }
    
    private func fetchData() {
        DataFetcher.shared.fetchCourses { courses in
//            let managedContext = self.persistentContainer.viewContext
//            guard let entity = NSEntityDescription.entity(forEntityName: "Course", in: managedContext) else {
//                print("Fetch data error")
//                return
//            }
//            let courses = NSManagedObject(entity: entity, insertInto: managedContext)
//
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save to Core Data: \(error)")
            }
        }
    }
    
    private func addTransactionObserver() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    @unknown default:
                        break
                    }
                }
            }
    }
    
    private func checkNetworkService() {
        NetworkService.shared.updateInfo(courseId: "1", values: "1") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("Error in app delegate --- \(error)")
            }
        }
    }
    
    private func loginUser() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    self.window?.rootViewController = TabBarController()
                }
            case .revoked, .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                DispatchQueue.main.async {
                    if UserDefaults.standard.bool(forKey: "introShowed") {
                        self.window?.rootViewController = LoginViewController()
                    } else {
                        self.window?.rootViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                    }
                }
            default:
                DispatchQueue.main.async {
                    self.window?.rootViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                }
            }
            DispatchQueue.main.async {
                self.window?.makeKeyAndVisible()
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }


}

