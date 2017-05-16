//
//  AnimationFactory.swift
//  BubbleRunner
//
//  Created by jlcardosa on 24/05/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationFactory {
    
    private static let valueYWhereBubbleStart = 280
    private static let valueXWhereBubbleStart = [-225, -75, 75, 225]
    private static let valueYWhereBubbleEnd:CGFloat = -700
    
    public static func animateWhenTap(bubble:Bubble) {
        var actions = [
            SKAction.scale(to: CGSize(width: bubble.size.width + 80, height: bubble.size.height + 80), duration: 0.25),
            SKAction.fadeOut(withDuration: 0.25),
            ]
        if backgroundMusicPlayer.isPlaying == true {
            actions.append(SKAction.playSoundFileNamed("hit-bubble.mp3", waitForCompletion: false))
        }
        bubble.run(SKAction.sequence([
            SKAction.group(actions),
            SKAction.removeFromParent()
            ])
        )
    }
    
    public static func animate(bubble:Bubble, duration:Double, endGame: @escaping () -> ()) {
        
        // Create the actions
        let fadeOut = SKAction.fadeOut(withDuration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let actionMove = SKAction.move(to: CGPoint(x: bubble.position.x, y: AnimationFactory.valueYWhereBubbleEnd), duration: duration)
        let actionMoveDone = SKAction.removeFromParent()
        let checkEndGame = SKAction.run {
            if bubble.typeColor == Bubble.TypeColor.Red {
                endGame()
            }
        }
        bubble.run(SKAction.sequence([fadeOut, SKAction.group([fadeIn, actionMove]), actionMoveDone, checkEndGame]))
    }
    
}
