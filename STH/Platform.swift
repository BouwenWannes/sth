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
    var platformWidth: CGFloat
    var platformHeight: CGFloat
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, position: CGPoint, scaleFactorPlatform: CGFloat) {
        self.width = width
        platformWidth = 0
        platformHeight = 0
        super.init()
        
        let platformLeft = SKSpriteNode(imageNamed: "platformLeft")
        
        platformLeft.setScale(scaleFactorPlatform)
        platformLeft.anchorPoint = CGPoint(x:0, y:0)
        platformLeft.position = position
        
        addChild(platformLeft)
        
        platformHeight = platformLeft.size.height
        platformWidth = platformLeft.size.width
        
        let numberOfCenterPlatforms = Int(arc4random_uniform(2))
        
        for _ in 0...numberOfCenterPlatforms {
            let platformCenter = SKSpriteNode(imageNamed: "platformCenter")
            
            platformCenter.setScale(scaleFactorPlatform)
            platformCenter.anchorPoint = CGPoint(x:0, y:0)
            platformCenter.position = CGPoint(x: position.x + platformWidth, y: position.y)
            
            addChild(platformCenter)

            platformWidth += platformCenter.size.width
        }
        
        let platformRight = SKSpriteNode(imageNamed: "platformRight")
        
        platformRight.setScale(scaleFactorPlatform)
        platformRight.anchorPoint = CGPoint(x:0, y:0)
        platformRight.position = CGPoint(x: position.x + platformWidth, y: position.y)
        
        addChild(platformRight)

        platformWidth += platformRight.size.width
        
        zPosition = 3
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: platformWidth, height: platformHeight),
                                    center: CGPoint(x: position.x + platformWidth / 2, y: position.y + platformHeight / 2))
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

