//
//  GameOverNode.swift
//  BubbleRunner
//
//  Created by jlcardosa on 21/05/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverNode: SKSpriteNode {

    var scorePointsLabel:SKLabelNode!
    var newHighScore:SKLabelNode!
    var retryButton:SKSpriteNode!
    var shareButton:SKSpriteNode!
    
    func initChildren() {
        self.isHidden = true
        self.scorePointsLabel = self.childNode(withName: "//scorePointsLabel") as! SKLabelNode
        self.newHighScore = self.childNode(withName: "//newHighScore") as! SKLabelNode
        self.retryButton = self.childNode(withName: "//RetryButton") as! SKSpriteNode
        self.shareButton = self.childNode(withName: "//ShareButton") as! SKSpriteNode
        self.newHighScore.isHidden = true
    }
    
    func pressReply() {
        
    }
    
    func pressShareSocial() {
        // Connect with FB
    }
    
    func updateScore(score:Int, maxScore:Bool) {
        self.scorePointsLabel.text = String(score)
        if maxScore {
            self.newHighScore.isHidden = false
            let actions = [
                SKAction.scale(to: 2, duration: 1),
                SKAction.scale(to: 1, duration: 1),
                ]
            self.newHighScore.run(SKAction.sequence(actions))
        }
    }
}
