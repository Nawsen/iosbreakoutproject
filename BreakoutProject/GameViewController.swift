//
//  GameViewController.swift
//  BreakoutProject
//
//  Created by Wannes Van Dorpe on 18/12/2015.
//  Copyright (c) 2015 Wannes Van Dorpe. All rights reserved.
//

import UIKit
import SpriteKit

//tutorial voor de basics van de game https://www.youtube.com/watch?v=Cgo7LCLy0mg

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let skView = self.view as! SKView
        if skView.scene == nil {
            skView.showsFPS = true
            skView.showsNodeCount = true
            let gameScene = GameScene(size: skView.bounds.size, level: 1)
            gameScene.viewController = self
            gameScene.scaleMode = .AspectFill
            
            skView.presentScene(gameScene)
        }
        
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
