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
import Network
import CallKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var callObserver = CXCallObserver()
    var loginCalled = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        //UIApplication.shared.isIdleTimerDisabled = true
        //self.window?.rootViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        //self.window?.rootViewController = LoginViewController()
        //loginUser()
        #if DEBUG
        UserDefaults.standard.setValue("19198704", forKey: "userIdentifier")
        self.window?.rootViewController = LoginViewController()
        self.window?.makeKeyAndVisible()
        #else
        loginUser()
        #endif
        //loginUser()
        callObserver.setDelegate(self, queue: nil) // nil queue means main thread
        registerStorePaymentHandler()
        addTransactionObserver()
        return true
    }
    
    @objc
    private func hasConnection() -> Bool {
        var URLString: String? = nil
        if let url = URL(string: "https://www.google.com") {
            do {
                URLString = try String(contentsOf: url)
            } catch {
                print(error)
            }
        }
        return URLString != nil ? true : false
    }
    
    //MARK: - Handle user credentials
    private func loginUser() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //print(KeychainItem.currentUserIdentifier)
        //let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") ?? ""
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            guard !self.loginCalled else { return }
            if KeychainItem.currentUserIdentifier == "" {
                //                    let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
                //                    let userIdentifier = String((0..<17).map{ _ in letters.randomElement()! })
                //                    UserDefaults.standard.set(userIdentifier, forKey: "userIdentifier")
            } else if KeychainItem.currentUserIdentifier != "" {
                UserDefaults.standard.set(KeychainItem.currentUserIdentifier, forKey: "userIdentifier")
            }
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
            self.loginCalled = true
        }
    }
    
    // MARK: - Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Architechik")
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
    
    //MARK: - In App Purchase
    private func addTransactionObserver() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            //print(#function)
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("CoursePurchased"), object: nil)
                // Unlock content
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func registerStorePaymentHandler() {
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
//            print(payment)
//            print(product)
            //print(#function)
            // return true if the content can be delivered by your app
            // return false otherwise
            return true
        }
    }
}

//MARK: - NetworkSpeedProviderDelegate
extension AppDelegate: NetworkSpeedProviderDelegate {
    func callWhileSpeedChange(networkStatus: NetworkStatus) {
        print(networkStatus)
    }
}

//MARK: - CXCallObserverDelegate
extension AppDelegate: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            print("Disconnected")
            UIApplication.shared.isIdleTimerDisabled = true
            UIApplication.shared.isIdleTimerDisabled = false
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("Dialing")
            UIApplication.shared.isIdleTimerDisabled = false
            UIApplication.shared.isIdleTimerDisabled = true
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("Incoming")
            UIApplication.shared.isIdleTimerDisabled = false
            UIApplication.shared.isIdleTimerDisabled = true
        }
        if call.hasConnected == true && call.hasEnded == false {
            print("Connected")
            UIApplication.shared.isIdleTimerDisabled = false
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    
}
