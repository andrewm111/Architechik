//
//  SwipeToDismissControllerDelegate.swift
//  Architechik
//
//  Created by Александр Цветков on 30.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

protocol SwipeToDismissControllerDelegate: UIViewController {
    var pan: UIPanGestureRecognizer { get set }
}

extension SwipeToDismissControllerDelegate {
    //MARK: - Handle swipe to dismiss gesture
    func handlePanChangedState() {
        let translationX = pan.translation(in: view).x
        guard translationX > 0 else { return }
        guard translationX < UIScreen.main.bounds.width / 3 else {
            pan.isEnabled = false
            animateDismiss()
            return
        }
        view.transform = CGAffineTransform(translationX: translationX, y: 0)
    }
    
    func handlePanEndedState() {
        let translationX = pan.translation(in: view).x
        if translationX > UIScreen.main.bounds.width * 0.22 {
            animateDismiss()
        } else {
            animateReturnToNormalState()
        }
    }
    
    func animateDismiss() {
        NotificationCenter.default.post(name: NSNotification.Name("SetProgress"), object: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        }) { _ in
            self.pan.isEnabled = true
            //self.dismiss(animated: false)
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    func animateReturnToNormalState() {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
}
