//
//  Global.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Globally accessible pieces of code, such as custom error objects, & all general extensions.

import UIKit
import QuartzCore

// MARK: -
enum NetError: Error {
    case connectionError
    case incorrectData
    case cancel
    case removeFile
    case syncError
    case permissionDenied
    case unknown
    case transactionValidation
    case noResponse
    case unauthorized
}

// MARK: -
extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

// MARK: -
extension UIColor {
    // Randomness
    class var random: UIColor {
        let hue = CGFloat(Double(arc4random() % 360) / 360.0) // 0.0 to 1.0
        let saturation: CGFloat = 0.7
        let brightness: CGFloat = 0.8
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    static var projectGreen: UIColor {
        return UIColor.init(red: 131, green: 200, blue: 68, alpha: 1)
    }
    
    static var projectBlue: UIColor {
        return UIColor.init(red: 49, green: 115, blue: 188, alpha: 1)
    }
    
    static var projectAddGreen: UIColor {
        return UIColor.init(red: 0, green: 221, blue: 130, alpha: 1)
    }
    
    static var projectWatermelon: UIColor {
        return UIColor.init(red: 245, green: 81, blue: 95, alpha: 1)
    }
}

// MARK: -
extension String {
    var localized: String {
        return localizedWithComment("")
    }
    
    func localizedWithComment(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}
