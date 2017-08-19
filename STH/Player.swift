//
//  Player.swift
//  STH
//
//  Created by Wannes Bouwen on 19/08/17.
//  Copyright © 2017 Wannes Bouwen. All rights reserved.
//

import SpriteKit

class Player: SKNode {
    var playerWalkingFrames : [SKTexture]!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x: CGFloat, y: CGFloat, scaleFactorPlayer: CGFloat) {
        super.init()
        
        let atlas = SKTextureAtlas(named: "Running")
        var textures = [SKTexture]()
        for index in 0...9 {
            textures.append(atlas.textureNamed(String(format: "Run%d.png", index + 1)))
        }
        playerWalkingFrames = textures
        
        position = CGPoint(x: x, y: y)
        zPosition = 2
        
        let sprite = SKSpriteNode(texture: playerWalkingFrames[0])
        sprite.setScale(scaleFactorPlayer / 10.0)
        addChild(sprite)
        
        // 1
        physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        // 2
        physicsBody?.isDynamic = true
        // 3
        physicsBody?.allowsRotation = false
        // 4
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
        
        
        physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
        physicsBody?.collisionBitMask = CollisionBitMask.foregroundCategory
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.contactTestBitMask = CollisionBitMask.foregroundCategory
        
        walkPlayer()
    }
    
    func walkPlayer() {
        children[0].run(SKAction.repeatForever(SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.07)))
    }
}

