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
    
    //Pause variables
    var pausedGame = false
    var muffinDx = CGFloat(0)
    var muffinDy = CGFloat(0)
    
    
    /* Setup your scene here */
    let manager = CMMotionManager()
    var wonMessage = SKSpriteNode()
    var lostMessage = SKSpriteNode()
    var timerLabel = SKLabelNode()
    var timerCount = SKLabelNode()
    
    var playAgain = SKSpriteNode()
    
    var goHome = SKSpriteNode()
    
    var muffin = SKSpriteNode()
    
    var difficulty : String?
    var levels = SKSpriteNode()
    var easyLevel = SKSpriteNode()
    var mediumLevel = SKSpriteNode()
    var hardLevel = SKSpriteNode()
    var resetLevel = SKSpriteNode()
    var pauseLabel = SKLabelNode()
    
    
    override func didMoveToView(view: SKView) {
        
        
        pauseLabel = self.childNodeWithName("pauseLabel") as! SKLabelNode
        pauseLabel.hidden = true
        
        wonMessage = self.childNodeWithName("wonMessage") as! SKSpriteNode
        lostMessage = self.childNodeWithName("lostMessage") as! SKSpriteNode
        
        wonMessage.hidden = true
        lostMessage.hidden = true
        
        timerLabel = self.childNodeWithName("timerLabel") as! SKLabelNode
        timerCount = self.childNodeWithName("timerCount") as! SKLabelNode
        
        timerLabel.hidden = true
        timerCount.hidden = true
    
        self.physicsWorld.contactDelegate = self
        
        runAction(SKAction.playSoundFileNamed("dog.mp3", waitForCompletion: false))
        
        resetLevel = self.childNodeWithName("resetLevel") as! SKSpriteNode
        resetLevel.hidden = true
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
    
    func startCountDown(){
        
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
            gameStart()
        } else if(node.name == "goHome"){ //Go back to Home menu
            let nextScene = HomeScene(fileNamed: "HomeScene")
            nextScene?.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFadeWithDuration(1))
        } else if(node.name == "easyLevel"){
            self.difficulty = "easy"
            hideLevels()
            setDifficulty()
            gameStart()
        } else if(node.name == "mediumLevel"){
            self.difficulty = "medium"
            hideLevels()
            setDifficulty()
            gameStart()
        } else if(node.name == "hardLevel"){
            self.difficulty = "hard"
            hideLevels()
            setDifficulty()
            gameStart()
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
        else if(node.name == "muffin" && pausedGame == false){   // Pause the game
            muffinDx = (muffin.physicsBody?.velocity.dx)!
            muffinDy = (muffin.physicsBody?.velocity.dy)!
            muffin.physicsBody?.affectedByGravity = false
            muffin.physicsBody?.velocity.dx = 0
            muffin.physicsBody?.velocity.dy = 0
            pauseLabel.hidden = false
            pausedGame = true
        }
        else if(node.name == "muffin" && pausedGame == true){
            muffin.physicsBody?.affectedByGravity = true
            muffin.physicsBody?.velocity.dx = muffinDx
            muffin.physicsBody?.velocity.dy = muffinDy
            pauseLabel.hidden = true
            pausedGame = false
        }
        
        
        
    }
    
    
    func gameStart(){
        
        muffin.physicsBody?.affectedByGravity = false
        
        timerLabel.hidden = false
        timerCount.hidden = false
        
        let wait1 = SKAction.waitForDuration(0.0)
        let wait2 = SKAction.waitForDuration(1.0)
        let wait3 = SKAction.waitForDuration(2.0)
        let wait4 = SKAction.waitForDuration(3.0)
        
        let run3 = SKAction.runBlock{
            self.timerCount.text = String(3)
        }
        let run2 = SKAction.runBlock{
            self.timerCount.text = String(2)
        }
        let run1 = SKAction.runBlock{
            self.timerCount.text = String(1)
        }
        let runStart = SKAction.runBlock{
            self.timerLabel.hidden = true
            self.timerCount.hidden = true
            self.muffin.physicsBody?.affectedByGravity = true
            self.timerCount.text = String(3)
        }
        
        runAction(SKAction.sequence([wait1, run3]))
        runAction(SKAction.sequence([wait2, run2]))
        runAction(SKAction.sequence([wait3, run1]))
        runAction(SKAction.sequence([wait4, runStart]))
        
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
        
        /* Possible rotation things */
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(10 * M_PI), duration: 120.0)
        self.childNodeWithName("rotateBar")?.runAction(rotateAction)


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
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
