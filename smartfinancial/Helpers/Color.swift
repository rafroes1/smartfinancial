//
//  Color.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    static let smartRed = UIColor(hex: 0xe31e27)
    static let smartLightRed = UIColor(hex: 0xea6a6b)
    static let smartWhite = UIColor(hex: 0xffffff)
    static let smartDarkGrey = UIColor(hex: 0x717477)
    static let smartLightGrey = UIColor(hex: 0xc4c4c4)
    static let smartBlack = UIColor(hex: 0x0a1a2a)
    static let smartGreen = UIColor(hex: 0x5eaa1d)
    static let smartYellow = UIColor(hex: 0xffbb00)
    
    static let transparentBlack = UIColor(hex: 0x000000, a: 0.5)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
