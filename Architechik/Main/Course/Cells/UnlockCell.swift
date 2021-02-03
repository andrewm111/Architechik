//
//  UnlockCell.swift
//  Architechik
//
//  Created by Александр Цветков on 18.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

class UnlockCell: TableViewCell {
    
    private let mainView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "buttonBuy")
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        //view.layer.cornerRadius = 25
        //view.backgroundColor = UIColor(hex: "613191")
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        let font = UIFont(name: "Arial-BoldMT", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributedString = NSAttributedString(string: "Оплатить курс", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        view.attributedText = attributedString
        //view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let unlockIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "appleIcon")?.withTintColor(.white)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var delegate: UnlockDelegate?

    func configure(withDelegate delegate: UnlockDelegate) {
        self.delegate = delegate
        initialSetup()
        setupSubviews()
    }
    
    //MARK: - Setup
    private func initialSetup() {
        selectionStyle = .none
        backgroundColor = .clear
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(unlockTapped))
        mainView.addGestureRecognizer(tap)
    }
    
    private func setupSubviews() {
        addSubview(mainView)
        mainView.addSubview(buttonView)
        //mainView.addSubview(unlockIcon)
        //mainView.addSubview(titleLabel)
        
        
        let mainViewWidth = UIScreen.main.bounds.width - UnlockButton.spacing.rawValue * 2
        let leftSpacing = UnlockButton.spacing.rawValue - (UnlockButton.getHorizontalShadow() * mainViewWidth)
        let mainViewTotalWidth = mainViewWidth + (UnlockButton.getHorizontalShadow() * 2 * mainViewWidth)
        let mainViewHeight = mainViewWidth * UnlockButton.getHeightOnWidthRatio()
        let topSpacing = 30 - (UnlockButton.getVerticalTopShadow() * mainViewHeight)
        let mainViewTotalHeight = mainViewHeight + (UnlockButton.getVerticalShadow() * mainViewHeight)
        mainView.frame = CGRect(x: leftSpacing, y: topSpacing, width: mainViewTotalWidth, height: mainViewTotalHeight)
        
        let stackView = UIStackView(arrangedSubviews: [unlockIcon, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        let stackViewWidth = titleLabel.intrinsicContentSize.width + 12 + 20
        
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            buttonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            buttonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UnlockButton.spacing.rawValue),
            buttonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UnlockButton.spacing.rawValue),
            
            stackView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: stackViewWidth),
            
            unlockIcon.heightAnchor.constraint(equalTo: unlockIcon.widthAnchor, multiplier: 1.25),
            unlockIcon.widthAnchor.constraint(equalToConstant: 20),
            //unlockIcon.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            //unlockIcon.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 14),
            //unlockIcon.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12),

//            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: buttonView.topAnchor, constant: 4),
//            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: buttonView.bottomAnchor, constant: -4),
//            titleLabel.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
//            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: buttonView.leadingAnchor, constant: 56),
//            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonView.trailingAnchor, constant: -14),
        ])
        
    }
    
    @objc
    private func unlockTapped() {
        delegate?.unlock()
    }
}

enum UnlockButton: CGFloat {
    case totalWidth = 1014 // with shadow
    case width = 950
    case totalHeight = 255 // with shadow
    case height = 169
    case spacing = 25
    case topToBottomShadowRatio = 1.205882352941176
    // heightDiff = ((1014 - 950) / 2) / height
    
    static func getWidthOnHeightRatio() -> CGFloat {
        return width.rawValue / height.rawValue
    }
    
    static func getHeightOnWidthRatio() -> CGFloat {
        return height.rawValue / width.rawValue
    }
    
    static func getHorizontalShadow() -> CGFloat {
        return ((UnlockButton.totalWidth.rawValue - UnlockButton.width.rawValue) / 2) / UnlockButton.width.rawValue
    }
    
    static func getVerticalShadow() -> CGFloat {
        return (UnlockButton.totalHeight.rawValue - UnlockButton.height.rawValue) / UnlockButton.height.rawValue
    }
    
    static func getVerticalBottomShadow() -> CGFloat {
        return getVerticalShadow() / (UnlockButton.topToBottomShadowRatio.rawValue + 1)
    }
    
    static func getVerticalTopShadow() -> CGFloat {
        return getVerticalBottomShadow() * UnlockButton.topToBottomShadowRatio.rawValue
    }
}

protocol UnlockDelegate {
    func unlock()
}
