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
    var backgroundNode: Background!
    var backgroundNode2: Background!
    
    var foregroundNode: Foreground!
    var foregroundNode2: Foreground!
    
    var player: Player!
    
    var scaleFactorBackground: CGFloat!
    var scaleFactorForeground: CGFloat!
    var scaleFactorPlayer: CGFloat!
    
    var previousTime: TimeInterval!
    var deltaTime: TimeInterval!
    
    var playerWalkingFrames : [SKTexture]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)

        previousTime = 0
        deltaTime = 0
        
        // Add some gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.5)
        
        // Set contact delegate
        physicsWorld.contactDelegate = self

        // Create background
        backgroundColor = SKColor.white
        scaleFactorBackground = self.size.width / 1000.0
        let positionBackGroundNode = CGPoint(x: 0, y:0)
        let positionBackGroundNode2 = CGPoint(x: size.width, y:0)
        backgroundNode = Background(width: size.width, position: positionBackGroundNode, scaleFactorBackground: scaleFactorBackground)
        backgroundNode2 = Background(width: size.width, position: positionBackGroundNode2, scaleFactorBackground: scaleFactorBackground)
        addChild(backgroundNode)
        addChild(backgroundNode2)
        
        // Create foreground
        scaleFactorForeground = self.size.width / 320.0
        let positionForeGroundNode = CGPoint(x: 0, y:0);
        let positionForeGroundNode2 = CGPoint(x: size.width, y:0);
        foregroundNode = Foreground(width: size.width, position: positionForeGroundNode, scaleFactorForeground: scaleFactorForeground)
        foregroundNode2 = Foreground(width: size.width, position: positionForeGroundNode2, scaleFactorForeground: scaleFactorForeground)
        addChild(foregroundNode)
        addChild(foregroundNode2)
        
        // Create player
        scaleFactorPlayer = self.size.width / 587.0
        player = Player(x: size.width * 0.1, y: 32 * scaleFactorForeground, scaleFactorPlayer: scaleFactorPlayer)
        addChild(player)
    }
    
    func updatePositionBackgroundAndForeground() {
        let displacementForeground = CGFloat(deltaTime) * size.width / 5.0
        let displacementBackground = CGFloat(deltaTime) * size.width / 30.0
        
        backgroundNode.updatePosition(displacement: displacementBackground)
        backgroundNode2.updatePosition(displacement: displacementBackground)
        
        foregroundNode.updatePosition(displacement: displacementForeground)
        foregroundNode2.updatePosition(displacement: displacementForeground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        deltaTime = currentTime - previousTime
        previousTime = currentTime
 
        updatePositionBackgroundAndForeground()
    }
}
