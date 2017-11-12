//
//  UIColor+Helpers.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 11/11/17.
//  Copyright © 2017 nhultz. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}
