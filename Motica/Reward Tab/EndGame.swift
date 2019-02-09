//
//  ViewController.swift
//  Motica
//
//  Created by MAD2 on 7/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class EndGame: UIViewController {
    var pet:[Pet] = []
    var account:[Account] = []
    
    @IBOutlet weak var imgsad: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchFromCoreData()
        let animal = UIImage(named: pet[petselected].picture! + "_meh")
        imgsad.image = animal
    }
    
    
    func fetchFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            pet = try managedContext.fetch(Pet.fetchRequest())
            account = try managedContext.fetch(Account.fetchRequest())
        }catch let error as NSError{
            print("Could not fetch \(error)  \(error.userInfo)")
        }
    }
    
    @IBAction func flappypet(_ sender: Any) {
        fetchFromCoreData()
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
            if game == "1"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "flappypet")
                vc.view.frame = (self.view?.frame)!
                vc.view.layoutIfNeeded()
                
                UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:{self.view?.window?.rootViewController = vc}, completion: { completed in})
            }
            else if game == "2"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "petjump")
                vc.view.frame = (self.view?.frame)!
                vc.view.layoutIfNeeded()
                
                UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:{self.view?.window?.rootViewController = vc}, completion: { completed in})
            }
            
        }
        if(account[0].money < 25){
            Toast.short(message: "You ran out of money :(", success: "1", failer: "0")
        }
        if(pet[petselected].health < 1){
            Toast.short(message: "Sharky is hungry.", success: "1", failer: "0")
        }
        if(pet[petselected].energy < 2){
            Toast.short(message: pet[petselected].name! + "is tired", success: "1", failer: "0")
        }
    }
    
    
}

