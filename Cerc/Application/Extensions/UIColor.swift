//
//  UIColor.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 25/9/21.
//

import UIKit

// https://stackoverflow.com/a/38435309
extension UIColor {
    func lighten(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darken(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: max(0.0, min(1.0, red + percentage/100)),
                        green:  max(0.0, min(1.0, green + percentage/100)),
                        blue:   max(0.0, min(1.0, blue + percentage/100)),
                        alpha: alpha)
        } else {
            return nil
        }
    }
}
