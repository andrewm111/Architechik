//
//  LessonView.swift
//  Architechik
//
//  Created by Александр Цветков on 06.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import WebKit

class LessonView: UIView {
    
    //MARK: - Subviews
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    var urlString = "" {
        didSet {
            guard let url = URL(string: urlString) else { return }
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    var delegate: WebDelegate?
    lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDragged))

    //MARK: - Init
    convenience init(withDelegate delegate: WebDelegate) {
        self.init(frame: .zero)
        self.delegate = delegate
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        self.backgroundColor = .black
        webView.backgroundColor = .black
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        addGestureRecognizer(pan)
//        guard let url = URL(string: urlString) else { return }
//        let urlRequest = URLRequest(url: url)
//        webView.load(urlRequest)
    }
    
    private func setupSubviews() {
        addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    //MARK: - Handling user events
    @objc
    private func viewDragged() {
        switch pan.state {
        case .changed:
            handlePanChangedState()
        case .ended:
            handlePanEndedState()
        default:
            break
        }
    }
}

//MARK: - WKUIDelegate, WKNavigationDelegate
extension LessonView: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //webView.scrollView.contentSize.width = UIScreen.main.bounds.width
        self.animateReturnToNormalState()
    }
}

//MARK: - SwipeToDismissViewDelegate
extension LessonView: SwipeToDismissViewDelegate {
}

//MARK: - UIScrollViewDelegate
extension LessonView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x != 0 {
//            scrollView.contentOffset.x = 0
//        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

protocol WebDelegate {
    func enablePanGestureRecognizer()
}
