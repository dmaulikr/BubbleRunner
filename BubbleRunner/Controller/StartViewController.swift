//
//  StartViewController.swift
//  TapRush
//
//  Created by jlcardosa on 16/03/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {

    @IBOutlet weak var playNowButton: UIButton!
    
    private var scheduledTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initBackgroundMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sendScreenView(name: "Start View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0,
                       options: [.repeat, .autoreverse, .allowUserInteraction],
                       animations: {
                        self.playNowButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },completion: nil
        )
        
        self.runTimer()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBall() {
        
        let valueLimitY = self.view.frame.height
        let valueLimitX = self.view.frame.width
        
        let ballSize:CGSize
        if UIDevice.current.userInterfaceIdiom == .phone {
            ballSize = CGSize(width: 45, height: 45)
        } else {
            ballSize = CGSize(width: 75, height: 75)
        }
        
        // Create sprite and view
        let bubble = Bubble(size: ballSize)
        let bubbleImage = UIImage(cgImage: (bubble.texture!.cgImage()))
        let bubbleImageView = UIImageView(image: bubbleImage)
        bubbleImageView.alpha = 0.4
        
        // Position where the bubble born
        let valueXWhereBubbleStart = CGFloat.random(min: 0, max: CGFloat(valueLimitX))
        let valueYWhereBubbleStart = CGFloat.random(min: 0, max: CGFloat(valueLimitY))
        bubbleImageView.frame = CGRect(origin: CGPoint(x: valueXWhereBubbleStart, y: valueYWhereBubbleStart), size: ballSize)
        
        // Add the bubble to the beginning of the array
        self.view.insertSubview(bubbleImageView, at: 0)
        
        // Create the actions
        UIView.animate(withDuration: 6.0, delay: 0,
                       animations: {
                        bubbleImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        },completion: { (finish: Bool) in
            bubbleImageView.removeFromSuperview()
        }
        )
    }
    
    private func runTimer() {
        self.scheduledTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                                   target: self,
                                                   selector: #selector(self.addBall),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    private func initBackgroundMusic() {
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
