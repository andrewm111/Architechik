//
//  AppDelegate.swift
//  Architechik
//
//  Created by Александр Цветков on 02.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
//        NetworkService.shared.buyCourse(courseId: "1") { result in
//            switch result {
//            case .success(_):
//                break
//            case .failure(let error):
//                print("Error in app delegate --- \(error)")
//            }
//        }
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                DispatchQueue.main.async {
//                    self.window?.rootViewController = TabBarController()
//                }
//            case .revoked, .notFound:
//                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    if UserDefaults.standard.bool(forKey: "introShowed") {
//                        self.window?.rootViewController = LoginViewController()
//                    } else {
//                        self.window?.rootViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//                    }
//                }
//            default:
//                DispatchQueue.main.async {
//                    self.window?.rootViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//                }
//            }
//            DispatchQueue.main.async {
//                self.window?.makeKeyAndVisible()
//            }
//        }
        return true
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

