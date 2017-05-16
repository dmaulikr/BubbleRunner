//
//  GameViewController.swift
//  BubblePicker
//
//  Created by jlcardosa on 13/02/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import AVFoundation

let startGameFromBeginning = "startGameFromBeginning"
let goToHome = "goToHome"
var backgroundMusicPlayer:AVAudioPlayer!

class GameViewController: UIViewController {

    var scene:GameScene?
    var isGameOver: Bool = false
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initBackgroundMusic()
        
        //Test Advert 
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //self.levelsButton.isHidden = true
        if let view = self.view as! SKView? {
            self.scene = GameScene(fileNamed: "GameScene")
            self.scene?.scaleMode = .aspectFit
            view.presentScene(scene!, transition: SKTransition.doorway(withDuration: 1))
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sendScreenView(name: "Game View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func initBackgroundMusic() {
        do {
            guard backgroundMusicPlayer == nil else {
                return
            }
            let bgMusicURL = Bundle.main.url(forResource: "bgMusic", withExtension: "wav")
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: bgMusicURL!)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            
            if Player.getInstance().sound == true {
                backgroundMusicPlayer.play()
            }
            
        } catch let error {
            print("Error loading the music: \(error.localizedDescription)")
        }
    }
}
