//
//  WebViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 27.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, SwipeToDismissDelegate {
    
    //MARK: - Subviews
    private let webView: WKWebView = {
        let view = WKWebView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(viewDragged))
    var urlString = ""
    private var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.webView.isMultipleTouchEnabled = false
        self.webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.addGestureRecognizer(pan)
        view.backgroundColor = .black
        webView.backgroundColor = .black
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        //guard let url = URL(string: "https://architechick.ru/courses/course2/lesson1.html") else { return }
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    private func setupSubviews() {
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
    }
}

//MARK: - UIScrollViewDelegate
extension WebViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            // move up
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//           // move down
//        }
//
//        // update the new position acquired
//        self.lastContentOffset = scrollView.contentOffset.y
//        print(lastContentOffset)
//        print(scrollView.contentSize)
//    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

