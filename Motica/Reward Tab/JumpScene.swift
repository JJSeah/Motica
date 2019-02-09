//
//  ViewController.swift
//  Motica
//
//  Created by MAD2 on 7/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//


import SpriteKit
import GameplayKit


enum GameState {
    case introLogo
    case playing
    case dead
}

class JumpScene: SKScene, SKPhysicsContactDelegate {
    var pet:[Pet] = []
    var gamescore:[Game] = []
    
    var player = SKSpriteNode()
    var obstacle = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    
    let jumpUp = SKAction.moveBy(x: 0, y: 200, duration: 0.6)
    let fallBack = SKAction.moveBy(x: 0, y: -200, duration: 0.6)
    var jumpAction = SKAction()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var gameState = GameState.introLogo
    
    func fetchFromCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            pet = try managedContext.fetch(Pet.fetchRequest())
            gamescore = try managedContext.fetch(Game.fetchRequest())
        }catch let error as NSError{
            print("Could not fetch \(error)  \(error.userInfo)")
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        
        createPlayer()
        createGround()
        createScore()
        createLogos()
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        jumpAction = SKAction.sequence([jumpUp, fallBack])
        
    }
    
    func createPlayer() {
        fetchFromCoreData()
        let playerTexture = SKTexture(imageNamed: pic+"_01")
        player = SKSpriteNode(imageNamed: pic+"_01")

        player.size = CGSize(width: 50, height: 50)
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.4)
        player.zPosition = 10
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size)
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
    
        addChild(player)
    }
    
    func createGround() {
        let groundLine = SKSpriteNode(color: UIColor.white, size: CGSize(width: size.width * 2, height: 5))
        groundLine.position = CGPoint(x: 0, y: size.height * 0.37)
        
        groundLine.physicsBody = SKPhysicsBody(rectangleOf: groundLine.size)
        groundLine.physicsBody?.isDynamic = false
        
        addChild(groundLine)
    }
    
    func createObstacles() {
        let obstacleTexture = SKTexture(imageNamed: "cactus")
        obstacle = SKSpriteNode(imageNamed: "cactus")
        obstacle.size = CGSize(width: 20, height: 60)
        obstacle.zPosition = 0
        obstacle.physicsBody = SKPhysicsBody(texture: obstacleTexture, size: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.name = "obstacle"
        
        let xPosition = frame.width + obstacle.frame.width
        
        addChild(obstacle)

        obstacle.position = CGPoint(x: xPosition, y: size.height * 0.39)
        
        let randDuration = random(min: CGFloat(1), max: CGFloat(1.5))
        let actionMove = SKAction.moveTo(x: -1, duration: TimeInterval(randDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([actionMove, actionMoveDone])
        
        obstacle.run(moveSequence,
                     completion: {
                        self.score += 1
        })
        
    }
    
    func startObstacles() {
        let create = SKAction.run {[unowned self] in
            self.createObstacles()
        }
        
        let wait = SKAction.wait(forDuration: 1.5)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever, withKey: "startObstacles")
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.white
        
        addChild(scoreLabel)
    }
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "touch")
        //logo.size = CGSize(width: 20, height: 20)
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        logo.zPosition = 20
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "black")
        gameOver.size = CGSize(width: 0, height: 0)
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .introLogo:
            gameState = .playing
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run {[unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startObstacles()
            }
            
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence, withKey: "start")
            
        case .playing:
            if player.action(forKey: "jump") == nil {
                player.run(jumpAction, withKey:"jump")
            }

            
        case .dead:
            let scene = JumpScene(size: size)
            
            self.view?.presentScene(scene)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "obstacle" || contact.bodyB.node?.name == "obstacle" {
            game = "2"
            if(score > gamescore[1].highscore){
                gamescore[1].highscore = Int16(score)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "End")
            vc.view.frame = (self.view?.frame)!
            vc.view.layoutIfNeeded()
            
            UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:{self.view?.window?.rootViewController = vc}, completion: { completed in})
            
            gameOver.alpha = 1
            gameState = .dead
        
            contact.bodyB.node?.removeFromParent()
            contact.bodyA.node?.removeFromParent()
            
            removeAllActions()
            
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
            // not used
    }
}
