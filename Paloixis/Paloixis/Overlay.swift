//
//  Overlay.swift
//  Paloixis
//
//  Created by Mr Yoshine on 23/02/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import SpriteKit
import AVFoundation



class Overlay: SKScene {
    
    var HealthRed : SKSpriteNode!
    var HealthGreen : SKSpriteNode!
    var ammoBarBackground : SKSpriteNode!
    var ammoBar : SKSpriteNode!
    var gearBox : SKSpriteNode!
    var gearStick : SKSpriteNode!
    var button : SKSpriteNode!
    var health : CGFloat = 1.0
    var overHeat : CGFloat = 0.0
    var overHeatTimmer : CGFloat = 0.0
    var scale : CGFloat = 1.0
    var gearSpeed : CGFloat = 0.0
    var inGear : Bool = false
    var fire : Bool = false
    var score : SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        setUp()
    }
    
    
    func setUp()
    {
        self.anchorPoint = CGPointMake(0.0, 0.0);
        self.scaleMode = SKSceneScaleMode.Fill;
        scale = 1.0
        
        HealthRed = SKSpriteNode(imageNamed: "Health_Bar_Red_Small.jpg")
        HealthRed.anchorPoint = CGPointMake(0, 0)
        HealthRed.position = CGPoint(x: 100, y: self.size.height-50)
        HealthRed.xScale = 0.2 * scale;
        HealthRed.yScale = 0.2 * scale;
       
        addChild(HealthRed)
        
        HealthGreen = SKSpriteNode(imageNamed: "Health_Bar_Green_Small.jpg")
        HealthGreen.anchorPoint = CGPointMake(0, 0)
        HealthGreen.position = CGPoint(x: 100, y: self.size.height-50)
        HealthGreen.xScale = 0.2 * scale * health;
        HealthGreen.yScale = 0.2 * scale;
        
        addChild(HealthGreen)
        
        ammoBarBackground = SKSpriteNode(imageNamed: "Fire_Shot_Empty.jpg")
        ammoBarBackground.anchorPoint = CGPointMake(0, 0)
        ammoBarBackground.position = CGPoint(x: self.size.width-250, y: self.size.height-50)
        ammoBarBackground.xScale = 0.2 * scale
        ammoBarBackground.yScale = 0.2 * scale
        
        addChild(ammoBarBackground)
        
        ammoBar = SKSpriteNode(imageNamed: "Fire_Shot_Bar.png")
        ammoBar.anchorPoint = CGPointMake(0, 0)
        ammoBar.position = CGPoint(x: self.size.width-250, y: self.size.height-50)
        ammoBar.xScale = 0.2 * scale * overHeat
        ammoBar.yScale = 0.2 * scale
        
        addChild(ammoBar)
        
        gearBox = SKSpriteNode(imageNamed: "Gear_Shift.png")
        gearBox.anchorPoint = CGPointMake(0, 0)
        gearBox.position = CGPoint(x: 100, y: 20)
        gearBox.xScale = 0.4 * scale
        gearBox.yScale = 0.2 * scale
        
        addChild(gearBox)
        
        gearStick = SKSpriteNode(imageNamed: "Gear_Shift_Stick.png")
        gearStick.anchorPoint = CGPointMake(0, 0)
        gearStick.name = "gearStick"
        gearStick.position = CGPoint(x: 110, y: 26.5)
        gearStick.xScale = 0.4 * scale
        gearStick.yScale = 0.4 * scale
        
        addChild(gearStick)
        
        button = SKSpriteNode(imageNamed: "Button_Up.png")
        button.anchorPoint = CGPointMake(0, 0)
        button.name = "Button"
        button.position = CGPoint(x: self.size.width-150, y: 10)
        button.xScale = 0.06 * scale
        button.yScale = 0.06 * scale
        
        addChild(button)
        
        score = SKLabelNode(text: "Score: ")
        score.position = CGPoint(x: (self.size.width/2)-5, y: self.size.height-50)
        score.xScale = 0.5
        score.yScale = 0.5
        addChild(score)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = (touch as UITouch).locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "gearStick" {
                    inGear = true
                } else if theName == "Button" {
                    fire = true
                    button.texture = SKTexture(imageNamed: "Button_Down.png")
                }
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if inGear {
            for touch: AnyObject in touches {
                let location = (touch as UITouch).locationInNode(self)
                if location.y > 26.5 && location.y < 66 {
                    gearStick.position = CGPoint(x: gearStick.position.x, y: location.y)
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var gearVariation : CGFloat = 66 - 26.5
        gearSpeed = (((gearStick.position.y - 26.5) / gearVariation) > 0.10) ? ((gearStick.position.y - 26.5) / gearVariation) : 0.10;
        inGear = false
        fire = false
        button.texture = SKTexture(imageNamed: "Button_Up.png")
    }

    override func update(currentTime: CFTimeInterval) {
        //decreaseHealth(0.01)
        if fire {
            shoot()
        }
        if overHeatTimmer == 0.0 {
            if overHeat >= 1.0 {
                overHeatTimmer += 1000;
                fire = false
            }
        } else {
            overHeatTimmer--
            overHeat -= 0.001
            if overHeat < 0.0 {
                overHeat = 0.0;
            }
            if overHeatTimmer < 0.0 {
                overHeatTimmer = 0.0
            }
            ammoBar.xScale = 0.2 * scale * overHeat
        }
    }
    
    func shoot(){
        if overHeat < 1.0 {
            overHeat += 0.01
            ammoBar.xScale = 0.2 * scale * overHeat
        }
    }
    
    func decreaseHealth(amount: CGFloat)
    {
        if health > 0.0 {
            health -= amount
            HealthGreen.xScale = 0.2 * scale * health;
        }
    }
    
    func setScore(scoreValue: Int) {
        score.text = NSString(format: "Score: %d",scoreValue)
    }
}
