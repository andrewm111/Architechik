//
//  UIColor + HexValue.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

extension UIColor {

  convenience init(hex: String, alpha: CGFloat = 1.0) {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) { cString.removeFirst() }

    if ((cString.count) != 6) {
      self.init(hex: "ff0000") // return red color for wrong hex input
      return
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }

}
