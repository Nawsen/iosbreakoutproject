//
//  GameScene.swift
//  BreakoutProject
//
//  Created by Wannes Van Dorpe on 18/12/2015.
//  Copyright (c) 2015 Wannes Van Dorpe. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController:UIViewController!
    var cLevel:Int = 1
    var fingerIsOnPaddle = false
    
    let ballCategoryName = "ball"
    let paddleCategoryName = "paddle"
    let brickCategoryName = "brick"
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    let ballCategory:UInt32 = 0x1 << 0
    let bottomCategory:UInt32 = 0x1 << 1
    let brickCategory:UInt32 = 0x1 << 2
    let paddleCategory:UInt32 = 0x1 << 3
    
    init(size: CGSize, level: Int){
        super.init(size: size)
        cLevel = level
        
        
        self.physicsWorld.contactDelegate = self
        
        
        //set de muziek
        let bgMusicUrl = NSBundle.mainBundle().URLForResource("bgMusic", withExtension: "mp3")
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicUrl!, fileTypeHint: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        //zet de achtergrondafbeelding
        let backgroundImage = SKSpriteNode(imageNamed: "bg2")
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        self.addChild(backgroundImage)
        
        //Verander de default physics van swiftkit naar onze persoonlijke physics
        //dit zorgt ervoor dat de bal gaat kaatsen op alle muren
        self.physicsWorld.gravity = CGVectorMake(0,0)
        let wordBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = wordBorder
        self.physicsBody?.friction = 0
        
        //laad de bal in
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPointMake(self.frame.size.width/4, self.frame.height/4)
        self.addChild(ball)
        
        //zet de physics van de ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        //impulse moet in het begin gegeven worden anders zal de bal gewoon stilstaan
        ////ball.physicsBody?.applyImpulse(CGVectorMake(1, 1))
        
        //laad de paddle in
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 2)
        self.addChild(paddle)
        
        //voeg physics toe
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.dynamic = false
        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        paddle.physicsBody?.categoryBitMask = paddleCategory
        
        ball.physicsBody?.contactTestBitMask = bottomCategory | brickCategory
        
        //set bricks
            let numberOfRows = 3
            let numberOfBricks = 4
            let brickWidth = self.frame.width/6
            let padding:Float = 20
            
            let offset:Float = (Float(self.frame.size.width) - (Float(brickWidth) * Float(numberOfBricks) + padding * (Float(numberOfBricks)-1)))/2
            
            for index in 1 ... numberOfRows{
                
                var yOffset:CGFloat{
                    switch index {
                    case 1:
                        return self.frame.size.height * 0.9
                    case 2:
                        return self.frame.size.height * 0.7
                    case 3:
                        return self.frame.size.height * 0.5
                    default:
                        return 0
                    }
                }
                
                for index in 1 ... numberOfBricks {
                    
                    let brick = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: brickWidth, height: self.frame.height/12))
                    
                    
                    let calc1:Float = Float(index) - 0.5
                    let calc2:Float = Float(index) - 1
                    
                    brick.position = CGPointMake(CGFloat(calc1 * Float(brick.frame.size.width)+2 + calc2 * padding + offset), yOffset)
                    
                    brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                    brick.physicsBody?.allowsRotation = false
                    brick.physicsBody?.friction = 0
                    brick.physicsBody?.dynamic = false
                    brick.name = brickCategoryName
                    brick.physicsBody?.categoryBitMask = brickCategory
                    
                    self.addChild(brick)
                    }

                    
                
                
            }

        
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        
        let body:SKPhysicsBody? = self.physicsWorld.bodyAtPoint(touchLocation)
        
        if body?.node?.name == paddleCategoryName {
            print("paddle touched")
            fingerIsOnPaddle = true
        }
    }

    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if fingerIsOnPaddle {
            let touch = touches.first
            let touchLoc = touch?.locationInNode(self)
            let prefTouchLoc = touch?.previousLocationInNode(self)
            
            let paddle = self.childNodeWithName(paddleCategoryName) as! SKSpriteNode
            
            var newXPos = paddle.position.x + (touchLoc!.x - prefTouchLoc!.x)
            
            newXPos = max(newXPos, paddle.size.width / 2 )
            newXPos = min(newXPos, self.size.width - paddle.size.width / 2)
            
            paddle.position = CGPointMake(newXPos, paddle.position.y)
            
            
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       fingerIsOnPaddle = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory {
            let gameOverScene = GameOverScene(size: self.frame.size, playerWon: false)
            gameOverScene.viewController = viewController
            self.view?.presentScene(gameOverScene)
        }
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == brickCategory {
            secondBody.node?.removeFromParent()
            if isGameWon() {
                //load next level
                
                let newLevelScene = GameScene(size: self.frame.size, level: cLevel + 1)
                newLevelScene.viewController = viewController
                self.view?.presentScene(newLevelScene)
            }
        }
    }
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        
        for nodeObject in self.children{
            let node = nodeObject as SKNode
            if node.name == brickCategoryName {
                numberOfBricks = numberOfBricks + 1
            }
        }
        return numberOfBricks <= 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
