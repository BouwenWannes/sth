//
//  Background.swift
//  STH
//
//  Created by Wannes Bouwen on 19/08/17.
//  Copyright © 2017 Wannes Bouwen. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    
    let width: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, position: CGPoint, scaleFactorBackground: CGFloat) {
        self.width = width
        super.init()
        
        let node = SKSpriteNode(imageNamed: "BG")
        
        node.setScale(scaleFactorBackground)
        node.anchorPoint = CGPoint(x:0, y:0)
        node.position = position
        
        addChild(node)
        
        zPosition = 1
    }
    
    func updatePosition(displacement: CGFloat) {
        position.x -= displacement
        
        if (position.x < -width) {
            position.x = 0
        }
    }
}
