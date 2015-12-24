//
//  GameOverScene.swift
//  BreakoutProject
//
//  Created by Wannes Van Dorpe on 18/12/2015.
//  Copyright © 2015 Wannes Van Dorpe. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var viewController:UIViewController?
    
    var returnButton:SKNode!
    var replayButton:SKNode!
    
    init(size: CGSize, playerWon:Bool, level:Int) {
        super.init(size:size)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let highscore = userDefaults.valueForKey("highscore"){
            let H = highscore as? NSNumber
            if Int(H!.description) < level {
               userDefaults.setValue(level, forKey: "highscore")
            }
        }
        else {
            userDefaults.setValue(level, forKey: "highscore")
        }
        
        let background = SKSpriteNode(imageNamed: "bg2")
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.addChild(background)
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverLabel.fontSize = 46
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 1.2)
        
        
        // maak de return to home screen button
        returnButton = SKSpriteNode(imageNamed: "ReturnButton")
        returnButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/2);
        self.addChild(returnButton)
        replayButton = SKSpriteNode(imageNamed: "AgainButton")
        replayButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)/2 + 35)
        
        self.addChild(replayButton)
        
        
        if playerWon{
            gameOverLabel.text = "You WIN!"
            
        } else {
            gameOverLabel.text = "You LOSE!"
            
        }
        
        self.addChild(gameOverLabel)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let breakoutGameScene = GameScene(size: self.size)
        //self.view?.presentScene(breakoutGameScene)
        
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if returnButton.containsPoint(location) {
                viewController!.performSegueWithIdentifier("returnStart", sender: viewController)
            }
            if replayButton.containsPoint(location) {
                let breakoutGameScene = GameScene(size: self.size, level: 1)
                breakoutGameScene.viewController = viewController
                self.view?.presentScene(breakoutGameScene)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

}
