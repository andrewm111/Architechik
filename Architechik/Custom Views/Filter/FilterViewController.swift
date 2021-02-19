//
//  FilterViewController.swift
//  Architechik
//
//  Created by Александр Цветков on 18.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var filterView: FilterView? {
        didSet {
            setupFilterView()
        }
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupFilterView() {
        guard let filterView = self.filterView else { return }
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.topAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
