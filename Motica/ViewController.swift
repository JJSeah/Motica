//
//  ViewController.swift
//  Motica
//
//  Created by MAD2 on 7/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

var pic = "something"

class ViewController: UIViewController {
    
    var pet:[Pet] = []
    var account:[Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //background.loadGif(name:"water")
        if(game=="list"){
            self.tabBarController?.selectedIndex = 1
            game = ""
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(game=="list"){
            self.tabBarController?.selectedIndex = 1
            game = ""
        }
        fetchFromCoreData()
        showhealth()
        

    }
    
    
    @IBOutlet weak var btnotter: UIButton!
    @IBOutlet weak var btnwhale: UIButton!
    @IBOutlet weak var btnshark: UIButton!
    @IBOutlet weak var healthbar: UIImageView!
    @IBOutlet weak var Gold: UILabel!
    @IBOutlet weak var petimage: UIImageView!
    @IBOutlet weak var energy: UIImageView!
    @IBOutlet weak var expimage: UIImageView!
    @IBOutlet weak var lbllvl: UILabel!
    @IBOutlet weak var lblhp: UILabel!
    @IBOutlet weak var lblenergy: UILabel!
    @IBOutlet weak var lblexp: UILabel!
    
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
    func showhealth() {
        
        if(pet[0].lock == 0){
            self.btnshark.isHidden = true
        }
        else{
            self.btnshark.isHidden = false
        }
        if(pet[1].lock == 0){
            self.btnwhale.isHidden = true
        }
        else{
            self.btnwhale.isHidden = false
        }
        if(pet[2].lock == 0){
            self.btnotter.isHidden = true
        }
        else{
            self.btnotter.isHidden = false
        }
        
        Gold.text! = String(account[0].money) + "  Gold"
        lbllvl.text! = "Level: " + String(pet[petselected].lvl)
        lblhp.text! = String(pet[petselected].health) + " / 5"
        lblenergy.text! = String(pet[petselected].energy) + " / 8"
        lblexp.text! = String(pet[petselected].exp) + " / 10"
        pic = pet[petselected].picture!
        
        if (pet[petselected].health == 0){
            let health = UIImage(named: "lifebar_0")!
            healthbar.image = health
            let animal = UIImage(named: pet[petselected].picture! + "_hungry")
            petimage.image = animal
        }
        else if (pet[petselected].health == 1){
            let health = UIImage(named: "lifebar_1")!
            healthbar.image = health
            let animal = UIImage(named: pet[petselected].picture! + "_hungry")
            petimage.image = animal
              Toast.short(message: "Feed me!", success: "1", failer: "0")
        }
        else if (pet[petselected].health == 2){
            let health = UIImage(named: "lifebar_2")!
            healthbar.image = health
            let animal = UIImage(named: pet[petselected].picture! + "_meh")
            petimage.image = animal
        }
        else if (pet[petselected].health == 3){
            let health = UIImage(named: "lifebar_3")!
            healthbar.image = health
            let animal = UIImage(named: pet[petselected].picture! + "_meh")
            petimage.image = animal
            
        }
        else if (pet[petselected].health == 4){
            let health = UIImage(named: "lifebar_4")!
            healthbar.image = health
            let animal = UIImage(named: pet[petselected].picture! + "_happy")
            petimage.image = animal
        }
        else if (pet[petselected].health == 5){
            let health = UIImage(named: "lifebar_5")!
            healthbar.image = health
            let animal = UIImage(named: pet[petselected].picture! + "_happy")
            petimage.image = animal
        }
        
        
        if (pet[petselected].energy == 0){
            let play = UIImage(named: "lifebar_0")!
            energy.image = play
        }
        else if (pet[petselected].energy == 1){
            let play = UIImage(named: "play_1")!
            energy.image = play
        }
        else if (pet[petselected].energy == 2 || pet[0].energy == 3){
            let play = UIImage(named: "play_2")!
            energy.image = play
        }
        else if (pet[petselected].energy == 4 || pet[0].energy == 5){
            let play = UIImage(named: "play_3")!
            energy.image = play
        }
        else if (pet[petselected].energy == 6 || pet[0].energy == 7){
            let play = UIImage(named: "play_4")!
            energy.image = play
        }
        else if (pet[petselected].energy == 8){
            let play = UIImage(named: "play_5")!
            energy.image = play
        }
        
        
        if (pet[petselected].exp == 0){
            let exp = UIImage(named: "lifebar_0")!
            expimage.image = exp
        }
        else if (pet[petselected].exp >= 1 && pet[petselected].exp <= 3){
            let exp = UIImage(named: "xp_1")!
            expimage.image = exp
        }
        else if (pet[petselected].exp >= 4 && pet[petselected].exp <= 5){
            let exp = UIImage(named: "xp_2")!
            expimage.image = exp
        }
        else if (pet[petselected].exp >= 6 && pet[petselected].exp <= 7){
            let exp = UIImage(named: "xp_3")!
            expimage.image = exp
        }
        else if (pet[petselected].exp >= 8 && pet[petselected].exp <= 9){
            let exp = UIImage(named: "xp_4")!
            expimage.image = exp
        }
        else if (pet[petselected].exp == 10){
            let exp = UIImage(named: "xp_5")!
            expimage.image = exp
        }
       
        

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    @IBAction func Feed(_ sender: Any) {
//        pet[0].health += 1
       
        if (pet[petselected].health < 5  && account[0].money >= 5){
            pet[petselected].health += 1
            account[0].money -= 5
        }
        if (pet[petselected].health == 5){
            Toast.short(message: pet[petselected].name! + " is Full!", success: "1", failer: "0")
        }
        if (account[0].money < 5){
            Toast.short(message: "You ran out of money :(", success: "1", failer: "0")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        showhealth()
    }
    @IBAction func Play(_ sender: Any) {
    
        if(pet[petselected].health > 1 && pet[petselected].energy != 8){
            pet[petselected].energy += 1;
            pet[petselected].health -= 1;
            pet[petselected].exp += 1;
        }
        if(pet[petselected].exp == 10){
            pet[petselected].exp = 0
            pet[petselected].lvl += 1
        }
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        showhealth()
    }
    
    @IBAction func shark(_ sender: Any) {
        let animal = UIImage(named: "shark_happy")
        petimage.image = animal
        petselected = 0
        showhealth()
    }
    
    @IBAction func whale(_ sender: Any) {
            let animal = UIImage(named: "whale_happy")
            petimage.image = animal
            petselected = 1
            showhealth()
    }
    
    @IBAction func otter(_ sender: Any) {
        let animal = UIImage(named: "otter_happy")
        petimage.image = animal
        petselected = 2
        showhealth()
    }
    
}

