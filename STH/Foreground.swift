//
//  Foreground.swift
//  STH
//
//  Created by Wannes Bouwen on 19/08/17.
//  Copyright © 2017 Wannes Bouwen. All rights reserved.
//

import SpriteKit

class Foreground: SKNode {
    
    var width: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, position: CGPoint, scaleFactorForeground: CGFloat) {
        self.width = width
        super.init()
        
        let xSpacing = 32.0 * scaleFactorForeground
        for index in 0...19 {
            // 3
            let node = SKSpriteNode(imageNamed: "tile")
            // 4
            node.setScale(scaleFactorForeground / 4.0)
            node.anchorPoint = position
            node.position = CGPoint(x: xSpacing * CGFloat(index), y: 0)
            //5
            addChild(node)
        }
        
        zPosition = 2
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: 32 * scaleFactorForeground), center: CGPoint(x: position.x + width / 2.0, y: 16 * scaleFactorForeground))
        physicsBody?.isDynamic = false
        
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
        
        physicsBody?.categoryBitMask = CollisionBitMask.foregroundCategory
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
