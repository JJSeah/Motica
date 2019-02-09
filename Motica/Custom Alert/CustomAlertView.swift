//
//  CustomAlertView.swift
//  Motica
//
//  Created by Seah Family on 12/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {
    var task:[Task] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var alertTextField: UITextField!
    @IBOutlet weak var NotesTextField: UITextField!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var inputdate: UITextField!
    
    private var datePicker: UIDatePicker?
    
    var delegate: CustomAlertViewDelegate?
    var selectedOption = 1
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTextField.becomeFirstResponder()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(CustomAlertView.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomAlertView.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        inputdate.inputView = datePicker
        alertTextField.text! = titles
        NotesTextField.text! = notes
        datePicker!.date = dates as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        inputdate.text! = dateFormatter.string(from: dates as Date)
        selectedOption = difficulty
        
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dateChanged(datePicker:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        inputdate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        cancelButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        cancelButton.addBorder(side: .Right, color: alertViewGrayColor, width: 1)
        okButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
   
    @IBAction func onTapCancelButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.okButtonTapped(selectedOption: selectedOption, title: alertTextField.text!, sub: NotesTextField.text!)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let task = Task(context: context)
        if (alertTextField.text! != ""){
            if(datePicker!.date >= dates as Date){
                task.title = alertTextField.text!
                task.subtext = NotesTextField.text!
                task.deletion = "N"
                task.difficulty = Int16(selectedOption)
                task.duedate = datePicker!.date
                appDelegate.saveContext()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Pet")
                vc.view.frame = (self.view?.frame)!
                vc.view.layoutIfNeeded()
                
                UIView.transition(with: self.view!, duration: 0, options: .transitionFlipFromRight, animations:{self.view?.window?.rootViewController = vc}, completion: { completed in})
                game = "list"
                self.dismiss(animated: true, completion: nil)
            }
            else{
                Toast.short(message: "Please enter a valid date", success: "1", failer: "0")
            }
        }
        else{
            Toast.short(message: "Please enter a title", success: "1", failer: "0")
        }
        
    }
    
    @IBAction func onTapSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("First option")
            selectedOption = 1
            break
        case 1:
            print("Second option")
            selectedOption = 2
            break
        case 2:
            print("Third option")
            selectedOption = 3
        default:
            break
        }
    }
}

