//
//  GameScene.swift
//  our_maze
//
//  Created by Sharol Chand on 5/6/16.
//  Copyright (c) 2016 Sharol Chand. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* Setup your scene here */
    let manager = CMMotionManager()
    var wonMessage = SKSpriteNode()
    var lostMessage = SKSpriteNode()
    
    
    //var playAgain = SKLabelNode()
    var playAgain = SKSpriteNode()
    
    
    
    var goHome = SKSpriteNode()
    
    var muffin = SKSpriteNode()
    var gameBackgroundMusic = SKAudioNode()
    var winningMusic = SKAudioNode()
    
    
    
    var difficulty : String?
    var levels = SKSpriteNode()
    var easyLevel = SKSpriteNode()
    var mediumLevel = SKSpriteNode()
    var hardLevel = SKSpriteNode()
    var resetLevel = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        
        wonMessage = self.childNodeWithName("wonMessage") as! SKSpriteNode
        lostMessage = self.childNodeWithName("lostMessage") as! SKSpriteNode
        
        wonMessage.hidden = true
        lostMessage.hidden = true
        
    
        self.physicsWorld.contactDelegate = self
        
        gameBackgroundMusic = SKAudioNode(fileNamed: "dog.mp3")
        gameBackgroundMusic.name = "bgmusic"
        addChild(gameBackgroundMusic)
        
        resetLevel = self.childNodeWithName("resetLevel") as! SKSpriteNode
        resetLevel.hidden = true
        
        
//        message = self.childNodeWithName("popUp") as! SKLabelNode
        playAgain = self.childNodeWithName("playAgain") as! SKSpriteNode
        playAgain.hidden = true
        
        goHome = self.childNodeWithName("goHome") as! SKSpriteNode
        goHome.hidden = true
        
        muffin = self.childNodeWithName("muffin") as! SKSpriteNode
        muffin.physicsBody?.affectedByGravity = false

        
        /* Level stuff */
        levels = self.childNodeWithName("levels") as! SKSpriteNode
        easyLevel = self.childNodeWithName("easyLevel") as! SKSpriteNode
        mediumLevel = self.childNodeWithName("mediumLevel") as! SKSpriteNode
        hardLevel = self.childNodeWithName("hardLevel") as! SKSpriteNode
        
        hideLines()
        
        
    }
    
    func hideLines(){
        self.childNodeWithName("easy1")?.hidden = true
        self.childNodeWithName("easy2")?.hidden = true
        self.childNodeWithName("easy3")?.hidden = true
        self.childNodeWithName("medium1")?.hidden = true
        self.childNodeWithName("medium2")?.hidden = true
        self.childNodeWithName("medium3")?.hidden = true
        self.childNodeWithName("hard1")?.hidden = true
        self.childNodeWithName("hard2")?.hidden = true
        self.childNodeWithName("hard3")?.hidden = true
    }
    
    
    func startGravity(){
        
        /* Manager Stuff */
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){
            (data, error) in
            
            self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 10, CGFloat((data?.acceleration.y)!) * 10)
        }
        muffin.physicsBody?.affectedByGravity = true
        
        /* Remove difficulty options */
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var ballHit: SKPhysicsBody
        var border: SKPhysicsBody
        
        if contact.bodyA.fieldBitMask < contact.bodyB.fieldBitMask{
            ballHit = contact.bodyA
            border = contact.bodyB
        }
        else{
            ballHit = contact.bodyB
            border = contact.bodyA
        }
        
        
        if(ballHit.fieldBitMask == 1 && border.fieldBitMask == 2){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            lostMessage.hidden = false
        }
        
        if(ballHit.fieldBitMask == 1 && border.fieldBitMask == 3){
            
            runAction(SKAction.playSoundFileNamed("chewing.mp3", waitForCompletion: true))
            wonMessage.hidden = false
        }
        
        muffin.physicsBody?.affectedByGravity = false
        muffin.physicsBody?.velocity.dx = 0
        muffin.physicsBody?.velocity.dy = 0
        muffin.hidden = true
        self.childNodeWithName("bgmusic")?.removeFromParent()
        
        playAgain.hidden = false
        goHome.hidden = false
        resetLevel.hidden = false
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        
        if(node.name == "playAgain"){
            self.resetCurrentScene()
        } else if(node.name == "goHome"){ //Go back to Home menu
            let nextScene = HomeScene(fileNamed: "HomeScene")
            nextScene?.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFadeWithDuration(2))
        } else if(node.name == "easyLevel"){
            self.difficulty = "easy"
            hideLevels()
            setDifficulty()
        } else if(node.name == "mediumLevel"){
            self.difficulty = "medium"
            hideLevels()
            setDifficulty()
        } else if(node.name == "hardLevel"){
            self.difficulty = "hard"
            hideLevels()
            setDifficulty()
        }
        else if(node.name == "resetLevel"){
            showLevels()
            playAgain.hidden = true
            goHome.hidden = true
            wonMessage.hidden = true
            lostMessage.hidden = true
            muffin.position = CGPointMake(904, 250)
            muffin.physicsBody?.velocity.dx = 0
            muffin.physicsBody?.velocity.dy = 0
            muffin.physicsBody?.affectedByGravity = false
            muffin.hidden = false
        }
        
    }
    
    func hideLevels(){
        self.levels.hidden = true
        self.easyLevel.hidden = true
        self.mediumLevel.hidden = true
        self.hardLevel.hidden = true
    }
    
    func showLevels(){
        resetLevel.hidden = true
        self.levels.hidden = false
        self.easyLevel.hidden = false
        self.mediumLevel.hidden = false
        self.hardLevel.hidden = false
        
    }
    
    func setDifficulty(){
        
        /* Difficulty Level */
        
        if (self.difficulty == "easy"){
            
            self.childNodeWithName("easy1")?.hidden = false
            self.childNodeWithName("easy1")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("easy1")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("easy1")?.physicsBody?.fieldBitMask = 2
            self.childNodeWithName("easy2")?.hidden = false
            self.childNodeWithName("easy2")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("easy2")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("easy2")?.physicsBody?.fieldBitMask = 2
            self.childNodeWithName("easy3")?.hidden = false
            self.childNodeWithName("easy3")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("easy3")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("easy3")?.physicsBody?.fieldBitMask = 2
            
            self.childNodeWithName("medium1")?.hidden = true
            self.childNodeWithName("medium1")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("medium1")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("medium1")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("medium2")?.hidden = true
            self.childNodeWithName("medium2")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("medium2")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("medium2")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("medium3")?.hidden = true
            self.childNodeWithName("medium3")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("medium3")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("medium3")?.physicsBody?.fieldBitMask = 1
            
            self.childNodeWithName("hard1")?.hidden = true
            self.childNodeWithName("hard1")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("hard1")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("hard1")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("hard2")?.hidden = true
            self.childNodeWithName("hard2")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("hard2")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("hard2")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("hard3")?.hidden = true
            self.childNodeWithName("hard3")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("hard3")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("hard3")?.physicsBody?.fieldBitMask = 1
            
            
//            self.childNodeWithName("hard1")?.removeFromParent()
//            self.childNodeWithName("hard2")?.removeFromParent()
//            self.childNodeWithName("hard3")?.removeFromParent()
//            self.childNodeWithName("medium1")?.removeFromParent()
//            self.childNodeWithName("medium2")?.removeFromParent()
//            self.childNodeWithName("medium3")?.removeFromParent()
        
        
        } else if(self.difficulty == "medium"){
            
            self.childNodeWithName("easy1")?.hidden = true
            self.childNodeWithName("easy1")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("easy1")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("easy1")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("easy2")?.hidden = true
            self.childNodeWithName("easy2")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("easy2")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("easy2")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("easy3")?.hidden = true
            self.childNodeWithName("easy3")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("easy3")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("easy3")?.physicsBody?.fieldBitMask = 1
            
            self.childNodeWithName("medium1")?.hidden = false
            self.childNodeWithName("medium1")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("medium1")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("medium1")?.physicsBody?.fieldBitMask = 2
            self.childNodeWithName("medium2")?.hidden = false
            self.childNodeWithName("medium2")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("medium2")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("medium2")?.physicsBody?.fieldBitMask = 2
            self.childNodeWithName("medium3")?.hidden = false
            self.childNodeWithName("medium3")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("medium3")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("medium3")?.physicsBody?.fieldBitMask = 2
            
            self.childNodeWithName("hard1")?.hidden = true
            self.childNodeWithName("hard1")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("hard1")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("hard1")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("hard2")?.hidden = true
            self.childNodeWithName("hard2")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("hard2")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("hard2")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("hard3")?.hidden = true
            self.childNodeWithName("hard3")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("hard3")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("hard3")?.physicsBody?.fieldBitMask = 1
        
        } else if(self.difficulty == "hard"){
        
            self.childNodeWithName("easy1")?.hidden = true
            self.childNodeWithName("easy1")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("easy1")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("easy1")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("easy2")?.hidden = true
            self.childNodeWithName("easy2")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("easy2")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("easy2")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("easy3")?.hidden = true
            self.childNodeWithName("easy3")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("easy3")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("easy3")?.physicsBody?.fieldBitMask = 1
            
            self.childNodeWithName("medium1")?.hidden = true
            self.childNodeWithName("medium1")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("medium1")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("medium1")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("medium2")?.hidden = true
            self.childNodeWithName("medium2")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("medium2")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("medium2")?.physicsBody?.fieldBitMask = 1
            self.childNodeWithName("medium3")?.hidden = true
            self.childNodeWithName("medium3")?.physicsBody?.categoryBitMask = 2
            self.childNodeWithName("medium3")?.physicsBody?.collisionBitMask = 1
            self.childNodeWithName("medium3")?.physicsBody?.fieldBitMask = 1
            
            self.childNodeWithName("hard1")?.hidden = false
            self.childNodeWithName("hard1")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("hard1")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("hard1")?.physicsBody?.fieldBitMask = 2
            self.childNodeWithName("hard2")?.hidden = false
            self.childNodeWithName("hard2")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("hard2")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("hard2")?.physicsBody?.fieldBitMask = 2
            self.childNodeWithName("hard3")?.hidden = false
            self.childNodeWithName("hard3")?.physicsBody?.categoryBitMask = 1
            self.childNodeWithName("hard3")?.physicsBody?.collisionBitMask = 2
            self.childNodeWithName("hard3")?.physicsBody?.fieldBitMask = 2
        
        }

        startGravity()

    }
    
    
    func resetCurrentScene(){
        
        playAgain.hidden = true
        goHome.hidden = true
        wonMessage.hidden = true
        lostMessage.hidden = true
        resetLevel.hidden = true
        
        muffin.position = CGPointMake(904, 250)
        muffin.physicsBody?.velocity.dx = 0
        muffin.physicsBody?.velocity.dy = 0
        muffin.physicsBody?.affectedByGravity = true
        muffin.hidden = false
        
        gameBackgroundMusic = SKAudioNode(fileNamed: "dog.mp3")
        gameBackgroundMusic.name = "bgmusic"
        addChild(gameBackgroundMusic)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
