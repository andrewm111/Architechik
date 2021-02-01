//
//  SwipeToDismissDelegate.swift
//  Architechik
//
//  Created by Александр Цветков on 30.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

protocol SwipeToDismissDelegate: UIViewController {
    var pan: UIPanGestureRecognizer { get set }
}

extension SwipeToDismissDelegate {
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
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        }) { _ in
            self.pan.isEnabled = true
            self.dismiss(animated: false)
        }
    }
    
    func animateReturnToNormalState() {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = .identity
        }
    }
}
