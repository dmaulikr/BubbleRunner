//
//  CGFloat.swift
//  BubblePicker
//
//  Created by jlcardosa on 20/02/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return self.random() * (max - min) + min
    }
}
