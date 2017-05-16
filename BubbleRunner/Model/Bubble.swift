//
//  Bubble.swift
//  BubblePicker
//
//  Created by jlcardosa on 20/02/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import UIKit
import SpriteKit

class Bubble: SKSpriteNode {

    enum TypeColor : Int {
        case Red = 0, Green, Yellow, Blue
        
        init() {
            self = TypeColor(rawValue: Int(arc4random_uniform(4)))! // range is 0 to 3
        }
        
        func getTexture() -> SKTexture {
            var imageNamed:String
            switch self {
            case .Red:
                imageNamed = "redBubble.png"
            case .Green:
                imageNamed = "greenBubble.png"
            case .Yellow:
                imageNamed = "yellowBubble.png"
            case .Blue:
                imageNamed = "blueBubble.png"
            default:
                imageNamed = "redBubble.png"
            }
            return SKTexture(imageNamed: imageNamed)
        }
    }
    
    var typeColor:TypeColor!
    
    init(size: CGSize) {
        typeColor = TypeColor()
        super.init(texture: typeColor.getTexture(), color: UIColor.black, size: size)
        self.zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
