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

class HomeScene: SKScene, SKPhysicsContactDelegate {
    
    /* Setup your scene here */

    
    override func didMoveToView(view: SKView) {
        

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
       
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if(node.name == "Main"){
            let nextScene = GameScene(fileNamed: "GameScene")
            nextScene?.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFadeWithDuration(1))
            
        } else if(node.name == "Ocean"){
            let nextScene = GameScene(fileNamed: "GameScene1")
            nextScene?.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFadeWithDuration(1))
            
        } else if(node.name == "Jungle"){
            let nextScene = GameScene(fileNamed: "GameScene2")
            nextScene?.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFadeWithDuration(1))
        }
        
        
        
        
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
