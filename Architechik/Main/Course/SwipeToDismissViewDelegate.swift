//
//  SwipeToDismissViewDelegate.swift
//  Architechik
//
//  Created by Александр Цветков on 06.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

protocol SwipeToDismissViewDelegate: LessonView {
    var pan: UIPanGestureRecognizer { get set }
}

extension SwipeToDismissViewDelegate {
    //MARK: - Handle swipe to dismiss gesture
    func handlePanChangedState() {
        let translationX = pan.translation(in: self).x
        guard translationX > 0 else { return }
        guard translationX < UIScreen.main.bounds.width / 3 else {
            pan.isEnabled = false
            animateDismiss()
            return
        }
        self.transform = CGAffineTransform(translationX: translationX, y: 0)
    }
    
    func handlePanEndedState() {
        let translationX = pan.translation(in: self).x
        if translationX > UIScreen.main.bounds.width * 0.22 {
            animateDismiss()
        } else {
            animateReturnToNormalState()
        }
    }
    
    func animateDismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        }) { _ in
            self.delegate?.enablePanGestureRecognizer()
            self.showBlackView()
            self.setBlackViewAlpha(1)
            self.pan.isEnabled = true
            //self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        }
    }
    
    func animateReturnToNormalState() {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}
