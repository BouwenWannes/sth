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


struct CollisionBitMask {
    static let playerCategory:UInt32 = 0x1 << 0
    static let foregroundCategory:UInt32 = 0x1 << 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var backgroundNode: SKNode!
    var backgroundNode2: SKNode!
    var midgroundNode: SKNode!
    var foregroundNode: SKNode!
    var foregroundNode2: SKNode!
    
    var player: SKNode!// Tap to Start
    
    var scaleFactorBackground: CGFloat!
    var scaleFactorForeground: CGFloat!
    var scaleFactorPlayer: CGFloat!
    
    var previousTime: TimeInterval!
    var deltaTime: TimeInterval!
    
    var playerWalkingFrames : [SKTexture]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
   /* func checkPhysics() {
        
        // Create an array of all the nodes with physicsBodies
        var physicsNodes = [SKNode]()
        
        //Get all physics bodies
        enumerateChildNodes(withName: "//.") { node, _ in
            if let _ = node.physicsBody {
                physicsNodes.append(node)
            } else {
                print("\(node.name) does not have a physics body so cannot collide or be involved in contacts.")
            }
        }
        
        //For each node, check it's category against every other node's collion and contctTest bit mask
        for node in physicsNodes {
            let category = node.physicsBody!.categoryBitMask
            // Identify the node by its category if the name is blank
            let name = node.name != nil ? node.name : "Category \(category)"
            let collisionMask = node.physicsBody!.collisionBitMask
            let contactMask = node.physicsBody!.contactTestBitMask
            
            // If all bits of the collisonmask set, just say it collides with everything.
            if collisionMask == UInt32.max {
                print("\(name) collides with everything")
            }
            
            for otherNode in physicsNodes {
                if (node != otherNode) && (node.physicsBody?.isDynamic == true) {
                    let otherCategory = otherNode.physicsBody!.categoryBitMask
                    // Identify the node by its category if the name is blank
                    let otherName = otherNode.name != nil ? otherNode.name : "Category \(otherCategory)"
                    
                    // If the collisonmask and category match, they will collide
                    if ((collisionMask & otherCategory) != 0) && (collisionMask != UInt32.max) {
                        print("\(name) collides with \(otherName)")
                    }
                    // If the contactMAsk and category match, they will contact
                    if (contactMask & otherCategory) != 0 {print("\(name) notifies when contacting \(otherName)")}
                }
            }
        }
    }*/
    
    override init(size: CGSize) {
        let atlas = SKTextureAtlas(named: "Running")
        var textures = [SKTexture]()
        for index in 0...9 {
            textures.append(atlas.textureNamed(String(format: "Run%02d.png", index + 1)))
        }
        playerWalkingFrames = textures
        super.init(size: size)
        
        previousTime = 0
        deltaTime = 0
        
        // Add some gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        
        // Set contact delegate
        physicsWorld.contactDelegate = self

        // Create background
        backgroundColor = SKColor.white
        scaleFactorBackground = self.size.width / 1000.0
        var positionBackGroundNode = CGPoint(x: 0, y:0)
        var positionBackGroundNode2 = CGPoint(x: size.width, y:0)
        backgroundNode = createBackgroundNode(position: positionBackGroundNode)
        backgroundNode.zPosition = 1
    
        backgroundNode2 = createBackgroundNode(position: positionBackGroundNode2)
        backgroundNode2.zPosition = 1
        addChild(backgroundNode)
        addChild(backgroundNode2)
        
        // Create foreground
        scaleFactorForeground = self.size.width / 320.0
        var positionForeGroundNode = CGPoint(x: 0, y:0);
        var positionForeGroundNode2 = CGPoint(x: size.width, y:0);
        foregroundNode = createForegroundNode(position: positionForeGroundNode)
        foregroundNode.zPosition = 2
        foregroundNode2 = createForegroundNode(position: positionForeGroundNode2)
        foregroundNode2.zPosition = 2
        addChild(foregroundNode)
        addChild(foregroundNode2)
        
        // Create player
        scaleFactorPlayer = self.size.width / 587.0
        player = createPlayer()
        player.zPosition = 2
        addChild(player)
        
        // Set properties of physicsBody
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.0))
        
        //checkPhysics()
        
        walkingPlayer()
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width * 0.1, y: 32 * scaleFactorForeground)
        
        let sprite = SKSpriteNode(imageNamed: "Run1.png")
        sprite.setScale(scaleFactorPlayer / 10.0)
        playerNode.addChild(sprite)
        
        // 1
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        // 2
        playerNode.physicsBody?.isDynamic = true
        // 3
        playerNode.physicsBody?.allowsRotation = false
        // 4
        playerNode.physicsBody?.restitution = 0.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.0
        
        
        playerNode.physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
        playerNode.physicsBody?.collisionBitMask = CollisionBitMask.foregroundCategory
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.contactTestBitMask = CollisionBitMask.foregroundCategory
        
        return playerNode
    }
    
    func createForegroundNode(position : CGPoint) -> SKNode {
        let fgNode = SKNode()
        
        let xSpacing = 32.0 * scaleFactorForeground
        for index in 0...19 {
            // 3
            let node = SKSpriteNode(imageNamed: "tile")
            // 4
            node.setScale(scaleFactorForeground / 4.0)
            node.anchorPoint = position
            node.position = CGPoint(x: xSpacing * CGFloat(index), y: 0)
            //5
            fgNode.addChild(node)
        }
        fgNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 32 * scaleFactorForeground), center: CGPoint(x: position.x + self.size.width / 2.0, y: 16 * scaleFactorForeground))
        fgNode.physicsBody?.isDynamic = false
        
        fgNode.physicsBody?.restitution = 0.0
        fgNode.physicsBody?.friction = 0.0
        fgNode.physicsBody?.angularDamping = 0.0
        fgNode.physicsBody?.linearDamping = 0.0
        
        fgNode.physicsBody?.categoryBitMask = CollisionBitMask.foregroundCategory
        fgNode.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        fgNode.physicsBody?.usesPreciseCollisionDetection = true
        fgNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        
        
        return fgNode
    }
    
    func createBackgroundNode(position : CGPoint) -> SKNode {
        // 1
        // Create the node
        let backgroundNode = SKNode()
        
        let node = SKSpriteNode(imageNamed: "BG")
        
        node.setScale(scaleFactorBackground)
        node.anchorPoint = CGPoint(x:0, y:0)
        node.position = position
        
        backgroundNode.addChild(node)
        
        return backgroundNode
    }
    
    func updatePositionBackgroundAndForeground() {
        let displacementForeground = CGFloat(deltaTime) * size.width / 5.0
        let displacementBackground = CGFloat(deltaTime) * size.width / 12.0
        backgroundNode.position.x = backgroundNode.position.x - displacementBackground
        backgroundNode2.position.x = backgroundNode2.position.x - displacementBackground
        foregroundNode.position.x = foregroundNode.position.x - displacementForeground
        foregroundNode2.position.x = foregroundNode2.position.x - displacementForeground
        
        if (backgroundNode.position.x < -size.width) {
            backgroundNode.position.x = 0
        }
        
        if (backgroundNode2.position.x < -size.width) {
            backgroundNode2.position.x = 0
        }
        
        if (foregroundNode.position.x < -size.width) {
            foregroundNode.position.x = 0
        }
        
        if (foregroundNode2.position.x < -size.width) {
            foregroundNode2.position.x = 0
        }
    }
    
 /*   func didBegin(_ contact: SKPhysicsContact) {
        NSLog("didBegin called");
        var firstBody: SKPhysicsBody!
        var secondBody: SKPhysicsBody!
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
        if(firstBody.categoryBitMask == CollisionBitMask.playerCategory || secondBody.categoryBitMask == CollisionBitMask.foregroundCategory)
        {
            NSLog("collision detected");
        }
        
        if(firstBody.categoryBitMask == CollisionBitMask.foregroundCategory || secondBody.categoryBitMask == CollisionBitMask.playerCategory)
        {
            NSLog("collision detected");
        }
        
    }
    */
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        deltaTime = currentTime - previousTime
        previousTime = currentTime
 
        updatePositionBackgroundAndForeground()
    }
    
    func walkingPlayer() {
        //This is our general runAction method to make our bear walk.
        player.run(SKAction.repeatForever(
            SKAction.animate(with: playerWalkingFrames,
                                         timePerFrame: 0.1,
                                         resize: false,
                                         restore: true)),
                       withKey:"walkingInPlaceBear")
    }
}
