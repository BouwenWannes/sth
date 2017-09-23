//
//  Player.swift
//  STH
//
//  Created by Wannes Bouwen on 19/08/17.
//  Copyright © 2017 Wannes Bouwen. All rights reserved.
//

import SpriteKit

enum PlayerAction: Int {
    case Walking = 0
    case Jumping
}

class Player: SKNode {
    var playerWalkingFrames : [SKTexture]!
    var playerJumpingUpFrames : [SKTexture]!
    var playerJumpingDownFrames : [SKTexture]!
    var state : PlayerAction!
    var runningAction : SKAction!
    var jumpingActionUp : SKAction!
    var jumpingActionDown : SKAction!
    var sprite : SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x: CGFloat, y: CGFloat, scaleFactorPlayer: CGFloat) {
        super.init()
        
        state = .Walking
        
        let atlasRunning = SKTextureAtlas(named: "Running")
        let atlasJumping = SKTextureAtlas(named: "Jumping")
        
        var texturesRunning = [SKTexture]()
        var texturesJumpingUp = [SKTexture]()
        var texturesJumpingDown = [SKTexture]()

        
        for index in 0...9 {
            texturesRunning.append(atlasRunning.textureNamed(String(format: "Run%d.png", index + 1)))
            if (index < 5) {
                texturesJumpingUp.append(atlasJumping.textureNamed(String(format: "Jump%d.png", index + 1)))
            }
            else {
                texturesJumpingDown.append(atlasJumping.textureNamed(String(format: "Jump%d.png", index + 1)))
            }
        }

        playerWalkingFrames = texturesRunning
        playerJumpingUpFrames = texturesJumpingUp
        playerJumpingDownFrames = texturesJumpingDown
        
        position = CGPoint(x: x, y: y)
        zPosition = 3
        
        sprite = SKSpriteNode(texture: playerWalkingFrames[0])
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
        physicsBody?.collisionBitMask = CollisionBitMask.foregroundCategory | CollisionBitMask.platformCategory
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.contactTestBitMask = CollisionBitMask.foregroundCategory | CollisionBitMask.platformCategory
        
        runningAction = SKAction.repeatForever(SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.07))
        jumpingActionUp = SKAction.repeat(SKAction.animate(with: playerJumpingUpFrames, timePerFrame: 0.07), count: 1)
        jumpingActionDown = SKAction.repeat(SKAction.animate(with: playerJumpingDownFrames, timePerFrame: 0.07), count: 1)
        
        walkPlayer()
    }
    
    func walkPlayer() {
        sprite.removeAllActions()
        sprite.run(runningAction, withKey: "running")
    }
    func jumpPlayerUp() {
        sprite.removeAllActions()
        sprite.run(jumpingActionUp, withKey: "flyingUp")
    }
    func jumpPlayerDown() {
        sprite.run(jumpingActionDown, withKey: "flyingDown")
    }
}

