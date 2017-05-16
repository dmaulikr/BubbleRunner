//
//  GameScene.swift
//  BubblePicker
//
//  Created by jlcardosa on 13/02/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var player:Player!
    private var gameLoop:SKAction!
    
    private var timerLabel:SKLabelNode!
    private var bestScore:SKLabelNode!
    private var soundControl:SKSpriteNode!
    private var timerControl:SKSpriteNode!
    private var targetBubble:SKSpriteNode!
    private var gameOverModal:GameOverNode!
    
    private var score = 0
    private var scheduledTimer:Timer!
    private var secondsBubbleWaitingInterval:Double = 1.0
    private var secondsBubbleFallingDown:Double = 5.0
    private var bubbleWaitingInterval:SKAction!
    
    private static let valueYWhereBubbleStart = 280
    private static let valueXWhereBubbleStart = [-225, -75, 75, 225]
    private static let valueYWhereBubbleEnd = -700
    
    override func didMove(to view: SKView) {
        
        // Init the level
        self.player = Player.getInstance()
        
        // Get values node from scene
        self.initChildren()
        
        self.resumeTime()
        self.gameOverModal.initChildren()
        self.printScoreLabel()
        self.setSoundControl()
        self.printBestScoreLabel()
        
        self.createGameLoop()
    }
    
    public func createGameLoop() {
        self.removeAction(forKey: "gameLoop")
        self.gameLoop = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addBall),
                self.bubbleWaitingInterval
                ])
        )
        run(self.bubbleWaitingInterval)
        run(self.gameLoop, withKey: "gameLoop")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let nodes = self.nodes(at: pos)
        if nodes.count != 0 {
            let nodeName = nodes[0].name
            if self.gameOverModal.isHidden == false {
                if (nodeName?.contains(self.gameOverModal.retryButton.name!))! {
                    self.pressRetry()
                    return
                }
                if (nodeName?.contains(self.gameOverModal.shareButton.name!))! {
                    self.gameOverModal.pressShareSocial()
                    return
                }
            } else {
                if nodeName == "bubble" && self.isPaused == false {
                    self.bubbleHitWithATouch(bubble: nodes[nodes.count-1] as! Bubble)
                    return
                }
                if nodeName == self.timerControl.name {
                    self.resumePauseTimeToogle()
                    return
                }
                if nodeName == self.soundControl.name {
                    self.soundControlToogle()
                    return
                }
            }
        }
    }

    func pressRetry() {
        self.score = 0
        self.secondsBubbleWaitingInterval = 1.0
        self.secondsBubbleFallingDown = 5.0
        self.resumeTime()
        self.removeAllBubbles()
        self.gameOverModal.isHidden = true
    }
    
    func increaseScore() {
        self.score += 1
        if (self.score % 10 == 0) {
            self.secondsBubbleWaitingInterval = self.secondsBubbleWaitingInterval - 0.025
            self.secondsBubbleFallingDown = self.secondsBubbleFallingDown - 0.10
            self.bubbleWaitingInterval = SKAction.wait(forDuration: self.secondsBubbleWaitingInterval)
            self.createGameLoop()
        }
        self.printScoreLabel()
    }
    
    func addBall() {
        let bubble = Bubble(size: CGSize(width: 90, height: 90))
        bubble.name = "bubble"
        
        // Determine where to spawn the ball along the Y axis
        let randomArrayPosition = Int(arc4random_uniform(UInt32(GameScene.valueXWhereBubbleStart.count)))
        
        // Position where the bubble born
        bubble.position = CGPoint(x: GameScene.valueXWhereBubbleStart[randomArrayPosition], y: GameScene.valueYWhereBubbleStart)
        
        // Add the ball to the scene
        addChild(bubble)
        
        AnimationFactory.animate(bubble: bubble, duration: self.secondsBubbleFallingDown, endGame: self.endGame)
    }
    
    func setSoundControl() {
        if (backgroundMusicPlayer.isPlaying == true) {
            self.soundControl.texture = SKTexture(imageNamed: "volume.png")
        } else {
            self.soundControl.texture = SKTexture(imageNamed: "mute.png")
        }
    }
    
    func soundControlToogle() {
        if (backgroundMusicPlayer.isPlaying == true) {
            self.soundControl.texture = SKTexture(imageNamed: "volume.png")
            backgroundMusicPlayer.pause()
            self.player.sound = false
        } else {
            self.soundControl.texture = SKTexture(imageNamed: "mute.png")
            backgroundMusicPlayer.play()
            self.player.sound = true
        }
        self.player.save()
    }
    
    func resumePauseTimeToogle() {
        if (self.isPaused != true) {
            self.pauseTime()
        } else {
            self.resumeTime()
        }
    }
    
    func pauseTime() {
        self.isPaused = true
        self.scheduledTimer.invalidate()
        self.timerControl.texture = SKTexture(imageNamed: "play-button.png")
    }
    
    func resumeTime() {
        self.isPaused = false
        self.runTimer()
        self.timerControl.texture = SKTexture(imageNamed: "pause-button.png")
    }
    
    func bubbleHitWithATouch(bubble: Bubble) {
        AnimationFactory.animateWhenTap(bubble: bubble)
    }
    
    func endGame() {
        self.pauseTime()
        self.gameOverModal.updateScore(score: self.score, maxScore: self.updateMaxScore())
        self.gameOverModal.isHidden = false
        self.player.save()
    }
    
    func updateMaxScore() -> Bool {
        if Int(self.player.maxScore) < self.score {
            self.player.maxScore = Int64(self.score)
            return true
        }
        return false
    }
    
    func printScoreLabel() {
        self.timerLabel.text = String(self.score)
    }
    
    func printBestScoreLabel() {
        self.bestScore.text = "Best: " + String(self.player.maxScore)
    }
    
    func runTimer() {
        self.scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                   target: self,
                                                   selector: #selector(self.increaseScore),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    func removeAllBubbles() {
        for node in self.children {
            if node.name == "bubble" {
                node.removeFromParent()
            }
        }
    }
    
    func initChildren() {
        self.timerLabel = self.childNode(withName: "//currentScore") as! SKLabelNode
        self.bestScore = self.childNode(withName: "//bestScore") as! SKLabelNode
        
        self.soundControl = self.childNode(withName: "//SoundControlNode") as! SKSpriteNode
        self.timerControl = self.childNode(withName: "//TimeControl") as! SKSpriteNode
        self.targetBubble = self.childNode(withName: "//targetNode") as! SKSpriteNode
        self.gameOverModal = self.childNode(withName: "//gameOver") as! GameOverNode
        
        self.bubbleWaitingInterval = SKAction.wait(forDuration: 1)
    }
}
