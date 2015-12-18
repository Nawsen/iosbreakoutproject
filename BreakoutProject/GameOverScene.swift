//
//  GameOverScene.swift
//  BreakoutProject
//
//  Created by Wannes Van Dorpe on 18/12/2015.
//  Copyright © 2015 Wannes Van Dorpe. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, playerWon:Bool) {
        super.init(size:size)
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.addChild(background)
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverLabel.fontSize = 46
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        if playerWon{
            gameOverLabel.text = "You WIN!"
            
        } else {
            gameOverLabel.text = "You LOSE!"
            
        }
        
        self.addChild(gameOverLabel)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let breakoutGameScene = GameScene(size: self.size)
        self.view?.presentScene(breakoutGameScene)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

}
