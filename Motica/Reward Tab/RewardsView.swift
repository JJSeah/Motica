//
//  ViewController.swift
//  Motica
//
//  Created by MAD2 on 7/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class RewardsView: UIViewController {
    var pet:[Pet] = []
    var account:[Account] = []
    var gamescore:[Game] = []
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var buywhale: UIButton!
    @IBOutlet weak var buyotter: UIButton!
    
    @IBOutlet weak var flappyscore: UILabel!
    
    @IBOutlet weak var jumpscore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    

    func fetchFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            pet = try managedContext.fetch(Pet.fetchRequest())
            account = try managedContext.fetch(Account.fetchRequest())
            gamescore = try managedContext.fetch(Game.fetchRequest())
        }catch let error as NSError{
            print("Could not fetch \(error)  \(error.userInfo)")
        }
    }

    @IBAction func flappypet(_ sender: Any) {
        if(account[0].money >= 25 && pet[petselected].health > 1 && pet[petselected].energy >= 2){
            account[0].money -= 25
            pet[petselected].exp += 1
            pet[petselected].health -= 1
            pet[petselected].energy -= 2
            
            if(pet[petselected].exp == 10){
                pet[petselected].exp = 0
                pet[petselected].lvl += 1
                Toast.short(message: pet[petselected].name! + " Level UP!", success: "1", failer: "0")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "flappypet")
            vc.view.frame = (self.view?.frame)!
            vc.view.layoutIfNeeded()
            
            UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:{self.view?.window?.rootViewController = vc}, completion: { completed in})
        }
        if(account[0].money < 25){
            Toast.short(message: "You ran out of money :(", success: "1", failer: "0")
        }
        if(pet[petselected].health < 1){
            Toast.short(message: "Feed " + pet[petselected].name!, success: "1", failer: "0")
        }
        if(pet[petselected].energy < 2){
            Toast.short(message: pet[petselected].name! + "is tired", success: "1", failer: "0")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    @IBAction func petjump(_ sender: Any) {
        if(account[0].money >= 25 && pet[petselected].health > 1 && pet[petselected].energy >= 2){
            account[0].money -= 25
            pet[petselected].exp += 1
            pet[petselected].health -= 1
            pet[petselected].energy -= 2
            
            if(pet[petselected].exp == 10){
                pet[petselected].exp = 0
                pet[petselected].lvl += 1
                Toast.short(message: pet[petselected].name! + " Level UP!", success: "1", failer: "0")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "petjump")
            vc.view.frame = (self.view?.frame)!
            vc.view.layoutIfNeeded()
            
            UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:{self.view?.window?.rootViewController = vc}, completion: { completed in})
        }
        if(account[0].money < 25){
            Toast.short(message: "You ran out of money :(", success: "1", failer: "0")
        }
        if(pet[petselected].health < 1){
            Toast.short(message: "Feed " + pet[petselected].name!, success: "1", failer: "0")
        }
        if(pet[petselected].energy < 2){
            Toast.short(message: pet[petselected].name! + "is tired", success: "1", failer: "0")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    @IBAction func buywhale(_ sender: Any) {
        if(account[0].money >= 100){
            account[0].money -= 100
            pet[1].lock = 1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
            update()
        }
    }
    
    @IBAction func buyotter(_ sender: Any) {
        if(account[0].money >= 100){
            account[0].money -= 100
            pet[2].lock = 1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
            update()
        }
    }
    
    
    func update() {
        fetchFromCoreData()
        gold.text! = String(account[0].money) + "  Gold"
        if(pet[1].lock == 1){
            self.buywhale.isHidden = true
        }
        if(pet[2].lock == 1){
            self.buyotter.isHidden = true
        }
        flappyscore.text! = String(gamescore[0].highscore)
        jumpscore.text! = String(gamescore[1].highscore)
    }
}

