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
        //initial-scale=1.0, maximum-scale=1.0, 
        //let view = WKWebView()
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        let view = WKWebView(frame: CGRect.zero, configuration: conf)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
        addSubview(blackView)
        
        NSLayoutConstraint.activate([
            blackView.topAnchor.constraint(equalTo: self.topAnchor),
            blackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
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
    
    //MARK: - External methods
    func showView() {
        self.animateReturnToNormalState()
    }
    
    func setBlackViewAlpha(_ alpha: CGFloat) {
        self.blackView.alpha = alpha
    }
    
    func showBlackView() {
        self.blackView.isHidden = false
    }
    
    func hideBlackView() {
        self.blackView.isHidden = true
    }
}

//MARK: - WKUIDelegate, WKNavigationDelegate
extension LessonView: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.setBlackViewAlpha(0)
        }, completion: { _ in
            self.hideBlackView()
        })
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none'")
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none'")
    }
    
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        delegate?.enablePanGestureRecognizer()
//    }
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

protocol WebDelegate: UIViewController {
    func enablePanGestureRecognizer()
}

extension WebDelegate {
    func showNetworkAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Проверьте подключение к сети", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
