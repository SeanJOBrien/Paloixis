
//
//  Game.swift
//  Paloixis
//
//  Created by Mr Yoshine on 11/03/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//
import SceneKit
import SpriteKit
import CoreMotion

class Game : NSObject, SCNSceneRendererDelegate {
    
    //Scene
    var scene : SCNScene!
    var scnView :SCNView!
    var cameraNode : SCNNode!
    var floorNode : SCNNode!
    var overlay : Overlay!
    var bulletTimer : Float = 0.0
    var bulletPool = NSMutableArray()
    var TargetPool = NSMutableArray()
    var viewController : UIViewController!
    var canEnd = true
    
    //Controls
    var motionManager : CMMotionManager!
    
    //Player
    var ship : Ship!
    
    
    //-------------------------------------------------------------------------
    // Scene Set Up
    //-------------------------------------------------------------------------
    func setup() {
        // create a new scene
        scene = SCNScene(named: "art.scnassets/spit.dae")!
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y:0, z: 15)
        
        // Create Player
        ship = Ship();
        ship.control = SCNNode()
        scene.rootNode.addChildNode(ship.control)
        ship.control.position = SCNVector3(x: 0, y:10, z: 0)
        
        // Setuo Rest Of Scene
        createPlayer()
        setupTargets()
        physicsLoad()
        controlLoad()
        
        // retrieve the SCNView
        scnView.delegate = self;
        scnView.backgroundColor = UIColor.blueColor()
        scnView.scene = scene
        
        let floor = self.makeFloor()
        scene.rootNode.addChildNode(floor)
        
        overlay = Overlay()
        overlay.size = scnView.bounds.size
        scnView.overlaySKScene = overlay;
        overlay.setScore(TargetPool.count)
    }
    func createPlayer() {
        ship.control = SCNNode()
        scene.rootNode.addChildNode(ship.control)
        ship.control.position = SCNVector3(x: 0, y:10, z: 0)
        
        ship.playerShip = SCNNode()
        scene.rootNode.addChildNode(ship.playerShip)
        ship.playerShip.position = SCNVector3(x: 0, y:0, z: 0)
        
        let boxg = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        ship.directionalNode = SCNNode(geometry: boxg)
        scene.rootNode.addChildNode(ship.directionalNode)
        ship.directionalNode.position = SCNVector3(x: 0, y:0, z: -15)
        
        // Load Modle nodes
        let pilot = scene.rootNode.childNodeWithName("pilot", recursively: true)!
        let cockpit = scene.rootNode.childNodeWithName("cockpit", recursively: true)!
        let left_wing = scene.rootNode.childNodeWithName("left_wing", recursively: true)!
        let right_wing = scene.rootNode.childNodeWithName("right_wing", recursively: true)!
        let rear = scene.rootNode.childNodeWithName("rear", recursively: true)!
        let wheel_support = scene.rootNode.childNodeWithName("wheel_support", recursively: true)!
        let landing_light = scene.rootNode.childNodeWithName("landing_light", recursively: true)!
        let glass = scene.rootNode.childNodeWithName("glass", recursively: true)!
        ship.body_front = scene.rootNode.childNodeWithName("body_front", recursively: true)!
        let reflect = scene.rootNode.childNodeWithName("reflect", recursively: true)!
        
        
        ship.playerShip.addChildNode(pilot)
        ship.playerShip.addChildNode(ship.body_front)
        ship.playerShip.addChildNode(cockpit)
        ship.playerShip.addChildNode(left_wing)
        ship.playerShip.addChildNode(right_wing)
        ship.playerShip.addChildNode(rear)
        ship.playerShip.addChildNode(wheel_support)
        ship.playerShip.addChildNode(landing_light)
        ship.playerShip.addChildNode(glass)
        ship.playerShip.addChildNode(reflect)
        ship.playerShip.addChildNode(cameraNode)
        ship.playerShip.addChildNode(ship.directionalNode)
        ship.control.addChildNode(ship.playerShip)
        
        // Set Scale
        pilot.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        cockpit.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        left_wing.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        right_wing.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        rear.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        wheel_support.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        landing_light.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        glass.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        ship.body_front.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
        reflect.scale = SCNVector3(x: 0.01,y: 0.01,z: 0.01)
    }
    
    func setupTargets()
    {
        let target = SCNSphere(radius: 1.52)
        target.firstMaterial!.diffuse.contents = UIColor.redColor()
        target.firstMaterial!.specular.contents = UIColor.whiteColor()
        
        let targetNode_1 = SCNNode(geometry: target)
        targetNode_1.scale = SCNVector3(x: 2,y: 2,z: 2)
        scene.rootNode.addChildNode(targetNode_1)
        targetNode_1.position = SCNVector3(x: 26, y:15, z: 1.922)
        TargetPool.addObject(targetNode_1)
        
        let targetNode_2 = SCNNode(geometry: target)
        targetNode_2.scale = SCNVector3(x: 2,y: 2,z: 2)
        scene.rootNode.addChildNode(targetNode_2)
        targetNode_2.position = SCNVector3(x: 17.603, y:10, z: -171.774)
        TargetPool.addObject(targetNode_2)
        
        let targetNode_3 = SCNNode(geometry: target)
        targetNode_3.scale = SCNVector3(x: 2,y: 2,z: 2)
        scene.rootNode.addChildNode(targetNode_3)
        targetNode_3.position = SCNVector3(x: -233.255, y:10, z: 174.482)
        TargetPool.addObject(targetNode_3)
        
        let targetNode_4 = SCNNode(geometry: target)
        targetNode_4.scale = SCNVector3(x: 2,y: 2,z: 2)
        scene.rootNode.addChildNode(targetNode_4)
        targetNode_4.position = SCNVector3(x: -233.255, y:10, z: 3.979)
        TargetPool.addObject(targetNode_4)
    }
    
    
    func physicsLoad() {
        ship.control.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: ship.body_front.physicsBody?.physicsShape )
        ship.playerShip.physicsBody?.restitution = 0.9
        
        
    }
    
    func controlLoad() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.3
        motionManager.gyroUpdateInterval = 0.3
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()) {
            (gyroData, error) in
            let acceleration = gyroData.rotationRate
            let accelX = CGFloat(acceleration.x)
            let accelY = CGFloat(acceleration.y)
            
            if(true){
                self.ship.playerShip.runAction(SCNAction.rotateByX(0.0, y: 0.0, z: accelX, duration: 1))
                var velocity : SCNVector3 = self.ship.control.convertPosition(self.ship.directionalNode.position, fromNode: self.ship.playerShip)
                velocity = SCNVector3(x: velocity.x * 4 * Float(self.overlay.gearSpeed), y: velocity.y * 4 * Float(self.overlay.gearSpeed), z: velocity.z * 4 * Float(self.overlay.gearSpeed))
                self.ship.control.physicsBody?.velocity = velocity
            }
            if(true){
                self.ship.playerShip.runAction(SCNAction.rotateByX(accelY, y: 0.0, z: 0.0, duration: 1))
            }
        }
    }
    
    //-------------------------------------------------------------------------
    // Logic Of Scene
    //-------------------------------------------------------------------------
    
    func renderer(aRenderer: SCNSceneRenderer!, updateAtTime time: NSTimeInterval) {
        bulletTimer--
        if overlay.fire && bulletTimer <= 0.0{
            let boxg = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1)
            var bullet = SCNNode(geometry: boxg)
            var velocity : SCNVector3 = self.ship.control.convertPosition(self.ship.directionalNode.position, fromNode: self.ship.playerShip)
            bullet.position = ship.control.presentationNode().position
            
            velocity = SCNVector3(x: velocity.x*3.0, y: velocity.y*3.0, z: velocity.z*3.0)
            bullet.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: bullet.physicsBody?.physicsShape)
            bullet.physicsBody?.velocity = velocity
            bullet.physicsBody?.restitution = 0.9
            
            bulletTimer = 3.0;
            
            bulletPool.addObject(bullet)
            
            self.scene.rootNode.addChildNode(bullet)
        } else if bulletPool.count > 1 && bulletTimer < -120.0{
            bulletPool[0].removeFromParentNode()
            bulletPool.removeObject(bulletPool[0])
        }
        if self.ship.control.presentationNode().position.y < 0.0{
            overlay.decreaseHealth(0.1)
            self.ship.control.position = SCNVector3(x: 0.0, y: 10.0, z: 0.0)
            if overlay.health <= 0.0{
                gameOver()
            }
        }
        if distance(self.ship.control.presentationNode().position, nodeB: SCNVector3Zero) > 500.0{
            self.ship.control.position = SCNVector3(x: self.ship.control.presentationNode().position.x * -1, y: self.ship.control.presentationNode().position.y, z: self.ship.control.presentationNode().position.z * -1)
        }
        for b in bulletPool {
            if b.presentationNode().position.y < 0.0 {
                b.removeFromParentNode()
                bulletPool.removeObject(b)
            }
        }
        for t in TargetPool
        {
            for b in bulletPool {
                if distance(b.presentationNode().position , nodeB: t.presentationNode().position) < 1.0{
                    t.removeFromParentNode()
                    TargetPool.removeObject(t)
                    b.removeFromParentNode()
                    bulletPool.removeObject(b)
                    overlay.setScore(TargetPool.count)
                    if canEnd && TargetPool.count == 0 {
                        victory()
                    }
                }
            }
        }
    }
    
    func gameOver() {
        if canEnd{
            canEnd = false
            viewController.performSegueWithIdentifier("GameOver", sender: self)
        }
    }
    
    func victory() {
        if canEnd{
            canEnd = false
            viewController.performSegueWithIdentifier("Victory", sender: self)
        }
    }
    
    //-------------------------------------------------------------------------
    // Functionality Of Scene
    //-------------------------------------------------------------------------
    
    func lighting() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeOmni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        scene.rootNode.addChildNode(ambientLightNode)
    }
    func makeFloor() -> SCNNode {
        let floor = SCNFloor()
        floor.reflectivity = 0
        let floorNode = SCNNode()
        floorNode.geometry = floor
        let floorMaterial = SCNMaterial()
        floorMaterial.litPerPixel = false
        floorMaterial.diffuse.contents = UIImage(named:"green2.png")
        floorMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        floorMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        floor.materials = [floorMaterial]
        return floorNode
    }
    func distance(nodeA: SCNVector3,nodeB: SCNVector3) -> Float{
        var x = (nodeB.x - nodeA.x)*(nodeB.x - nodeA.x)
        var y = (nodeB.y - nodeA.y)*(nodeB.y - nodeA.y)
        var z = (nodeB.z - nodeA.z)*(nodeB.z - nodeA.z)
        var distance = sqrt(x + y + z)
    
        return distance
    }
}