//
//  GameScene.swift
//  EndlessRunner
//
//  Created by Wannes Bouwen on 22/03/17.
//  Copyright © 2017 Wannes Bouwen. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    var backgroundNode: SKNode!
    var midgroundNode: SKNode!
    var foregroundNode: SKNode!
    
    var player: SKNode!// Tap to Start
    
    var scaleFactorBackground: CGFloat!
    var scaleFactorForeground: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Add some gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        // Set contact delegate
        physicsWorld.contactDelegate = self

        // Create background
        backgroundColor = SKColor.white
        scaleFactorBackground = self.size.width / 1000
        var positionBackGroundNode = CGPoint(x: 0, y:0)
        backgroundNode = createBackgroundNode(position: positionBackGroundNode)
        backgroundNode.zPosition = 1
        addChild(backgroundNode)
        
        // Create foreground
        scaleFactorForeground = self.size.width / 320.0
        var positionForeGroundNode = CGPoint(x: 0, y:0);
        foregroundNode = createForegroundNode(position: positionForeGroundNode)
        foregroundNode.zPosition = 2
        addChild(foregroundNode)
        
        // Create player
        //player = createPlayer()
        //foregroundNode.addChild(player)
        
        // Set properties of physicsBody
        //player.physicsBody?.isDynamic = true
        //player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.2)
        
        let sprite = SKSpriteNode(imageNamed: "Player")
        playerNode.addChild(sprite)
        
        // 1
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        // 2
        playerNode.physicsBody?.isDynamic = false
        // 3
        playerNode.physicsBody?.allowsRotation = false
        // 4
        playerNode.physicsBody?.restitution = 1.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.0
        
        return playerNode
    }
    
    func createForegroundNode(position : CGPoint) -> SKNode {
        let foregroundNode = SKNode()
        
        let xSpacing = 32.0 * scaleFactorForeground
        for index in 0...19 {
            // 3
            let node = SKSpriteNode(imageNamed: "tile")
            // 4
            node.setScale(scaleFactorForeground / 4.0)
            node.anchorPoint = position
            node.position = CGPoint(x: xSpacing * CGFloat(index), y: 0)
            //5
            foregroundNode.addChild(node)
        }
        
        return foregroundNode
    }
    
    func createBackgroundNode(position : CGPoint) -> SKNode {
        // 1
        // Create the node
        let backgroundNode = SKNode()
        
        let node = SKSpriteNode(imageNamed: "BG")
        
        node.setScale(scaleFactorBackground)
        node.anchorPoint = position
        
        backgroundNode.addChild(node)
        
        return backgroundNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}