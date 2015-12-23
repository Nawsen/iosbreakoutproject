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
    
    var ball:SKSpriteNode!
    var ballInMotion:Bool = false
    
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
        ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        
        
        
        //zet de physics van de ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        //impulse moet in het begin gegeven worden anders zal de bal gewoon stilstaan
        
        
        //laad de paddle in
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 2)
        self.addChild(paddle)
        
        ball.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 2 + ball.frame.size.height)
        self.addChild(ball)
        
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
        
        for l in 1 ... cLevel {
        //set bricks
            let numberOfRows = 3
            let numberOfBricks = 4
            var brickWidth = (self.frame.width/6)
            var padding:Float = 20
            if l == 2 {
                brickWidth = brickWidth - 2
            }
            if l == 3 {
                brickWidth = brickWidth - 6
            }
            if l == 4 {
                brickWidth = brickWidth - 10
            }
            if l == 5 {
                brickWidth = brickWidth - 14
            }
            
            
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
                    var brick: SKSpriteNode!
                    var calc1:Float!
                    var calc2:Float!
                    if l == 1 {
                        brick = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: brickWidth, height: self.frame.height/12))
                        calc1 = Float(index) - 0.5
                        calc2 = Float(index) - 1
                        brick.position = CGPointMake(CGFloat(calc1 * Float(brickWidth) + calc2 * padding + offset), yOffset)
                        brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: brickWidth, height: self.frame.height/12))

                    }
                    if l == 2 {
                        brick = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: brickWidth, height: self.frame.height/12 - 2))
                        calc1 = Float(index) - 0.50
                        calc2 = Float(index) - 1
                        padding = 22
                        brick.position = CGPointMake(CGFloat((calc1 * Float(brickWidth) + calc2 * padding + offset) - 3), yOffset)
                        brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: brickWidth, height: self.frame.height/12 - 4))

                    }
                    if l == 3 {
                        brick = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: brickWidth, height: self.frame.height/12 - 6))
                        calc1 = Float(index) - 0.50
                        calc2 = Float(index) - 1
                        padding = 26
                        brick.position = CGPointMake(CGFloat((calc1 * Float(brickWidth) + calc2 * padding + offset) - 9), yOffset)
                        brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: brickWidth, height: self.frame.height/12 - 8))
                        
                    }
                    if l == 4 {
                        brick = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: brickWidth, height: self.frame.height/12 - 10))
                        calc1 = Float(index) - 0.50
                        calc2 = Float(index) - 1
                        padding = 30
                        brick.position = CGPointMake(CGFloat((calc1 * Float(brickWidth) + calc2 * padding + offset) - 15), yOffset)
                        brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: brickWidth, height: self.frame.height/12 - 12))
                        
                    }
                    if l == 5 {
                        brick = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width: brickWidth, height: self.frame.height/12 - 14))
                        calc1 = Float(index) - 0.50
                        calc2 = Float(index) - 1
                        padding = 34
                        brick.position = CGPointMake(CGFloat((calc1 * Float(brickWidth) + calc2 * padding + offset) - 21), yOffset)
                        brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: brickWidth, height: self.frame.height/12 - 16))
                        
                    }
                    
                    
                    
                    brick.physicsBody?.allowsRotation = false
                    brick.physicsBody?.friction = 0
                    brick.physicsBody?.dynamic = false
                    brick.name = brickCategoryName
                    brick.physicsBody?.categoryBitMask = brickCategory
                    
                    self.addChild(brick)
                    }
                
                }
                    
                
                
            }

        
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)

        if !ballInMotion{
            ball.physicsBody?.applyImpulse(CGVectorMake(0.5, 1))
            ballInMotion = true
        }
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
            let gameOverScene = GameOverScene(size: self.frame.size, playerWon: false, level: cLevel - 1)
            gameOverScene.viewController = viewController
            self.view?.presentScene(gameOverScene)
        }
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == brickCategory {
            secondBody.node?.removeFromParent()
            if isGameWon() {
                if cLevel > 4 {
                    //load victory screen
                    let victoryScene = GameOverScene(size: self.frame.size, playerWon: true, level: cLevel)
                    victoryScene.viewController = viewController
                    self.view?.presentScene(victoryScene)
                }
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
