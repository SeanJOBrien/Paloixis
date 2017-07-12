//
//  GameViewController.swift
//  Paloixis
//
//  Created by Mr Yoshine on 26/10/2014.
//  Copyright (c) 2014 WIT. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit


class GameViewController: UIViewController {
    
    var gameDelagate :Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDelagate = Game();
        gameDelagate.scnView = self.view as SCNView
        gameDelagate.setup();
        gameDelagate.viewController = self
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
