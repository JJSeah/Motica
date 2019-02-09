//
//  ViewController.swift
//  Motica
//
//  Created by MAD2 on 7/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit

class JumpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = JumpScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        //scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
