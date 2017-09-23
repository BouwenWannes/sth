//
//  Platform.swift
//  STH
//
//  Created by Wannes Bouwen on 23/09/17.
//  Copyright © 2017 Wannes Bouwen. All rights reserved.
//

import SpriteKit

class Platform: SKNode {
    
    let width: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, position: CGPoint, scaleFactorPlatform: CGFloat) {
        self.width = width
        super.init()
        
        let node = SKSpriteNode(imageNamed: "tile")
        
        node.setScale(scaleFactorPlatform)
        node.anchorPoint = CGPoint(x:0, y:0)
        node.position = position
        
        addChild(node)
        
        zPosition = 3
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width, height: node.size.height), center: CGPoint(x: position.x + node.size.width / 2, y: position.y + node.size.height / 2))
        physicsBody?.isDynamic = false
        
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
        
        physicsBody?.categoryBitMask = CollisionBitMask.platformCategory
        physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
    }
    
    func updatePosition(displacement: CGFloat) {
        position.x -= displacement
        
        if (position.x < -width) {
            position.x = 0
        }
    }
}

