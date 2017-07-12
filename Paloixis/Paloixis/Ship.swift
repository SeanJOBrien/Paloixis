//
//  Ship.swift
//  Paloixis
//
//  Created by Mr Yoshine on 15/03/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import Foundation
import SceneKit

class Ship : NSObject {
    var control :SCNNode!
    var playerShip :SCNNode!
    var ship : SCNNode!
    var directionalNode :SCNNode!
    var shipRotationX : CGFloat = 0.0
    var shipRotationY : CGFloat = 0.0
    var body_front :SCNNode!
}