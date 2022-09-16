//
//  Dimensions.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import Foundation
import UIKit

extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }
}

extension UIColor {
    convenience init(_ r: Double, _ g: Double, _ b: Double, _ a: Double) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    var qBlack: UIColor {
        UIColor(0.0, 0.0, 0.0, 1.0)
    }
    
    var qBlue: UIColor {
        UIColor(41.0, 39.0, 76.0, 1.0)
    }
    
    var qPurple: UIColor {
        UIColor(126.0, 82.0, 160.0, 1.0)
    }
    
    var qRed: UIColor {
        UIColor(191.0, 26.0, 47.0, 1.0)
    }
    
    var qGreen: UIColor {
        UIColor(30.0, 215.0, 96.0, 1.0)
    }
    
    var qYellow: UIColor {
        UIColor(255.0, 190.0, 0.0, 1.0)
    }
}


//font names: "Futura-Medium", "Futura-MediumItalic", "Futura-Bold", "Futura-CondensedMedium", "Futura-CondensedExtraBold"
