//
//  FeaturesViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class FeaturesViewController: IndexableViewController {
    
    private let featuresImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "features")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var featureImageHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        view.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(FeatureCell.self)
    }
    
    private func setupSubviews() {
        view.addSubview(featuresImageView)
        view.addSubview(tableView)
        
        if let imageWidth = featuresImageView.image?.size.width, let imageHeight = featuresImageView.image?.size.height {
            let width = UIScreen.main.bounds.width - 28
            let ratio = imageHeight / imageWidth
            let height = width * ratio
            featureImageHeight = height
            featuresImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        NSLayoutConstraint.activate([
            featuresImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            featuresImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            featuresImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            
            tableView.topAnchor.constraint(equalTo: featuresImageView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            tableView.leadingAnchor.constraint(equalTo: featuresImageView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: featuresImageView.trailingAnchor),
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension FeaturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = (UIScreen.main.bounds.height - featureImageHeight - 32) / 4
        return rowHeight
        //return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeatureCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(forType: FeatureType.allCases[indexPath.row])
        return cell
    }
}
