import Foundation
import UIKit
import CoreData

var titles = ""
var notes = ""
var dates = NSDate()
var difficulty = 1
var row = -1

class TaskTableViewController: UITableViewController {
    var task:[Task] = []
    var account:[Account] = []
    var tasks: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFromCoreData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchFromCoreData()
        tableView.reloadData()
    }
    
    func fetchFromCoreData(){
        print("Coredata fetch")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            task = try managedContext.fetch(Task.fetchRequest())
            account = try managedContext.fetch(Account.fetchRequest())
        }catch let error as NSError{
            print("Could not fetch \(error)  \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return task.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? tasktableviewcell  else {
            fatalError("The dequeued cell is not an instance of tasktableviewcell.")
        }
        
        let name = task[indexPath.row].title
        let subtext = task[indexPath.row].subtext
        let ddate = task[indexPath.row].duedate
        let money = account[0].money
        let components = Set<Calendar.Component>([.day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: dates as Date, to: ddate!)
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //print (ddate)
        let numofdays = (differenceOfDate.day!) + (differenceOfDate.month!*30) + (differenceOfDate.year!*365)
        
        let dateString = String(stringInterpolationSegment: numofdays)
        
        cell.txtTitle.text = name
        cell.txtNotes.text = subtext
        cell.txtDate.text = dateString + " Days Left"
        
        //add the check box
        if  (task[indexPath.row].deletion == "Y") {
            let image = UIImage(named: "tabbar_todos")!.withRenderingMode(.alwaysTemplate)
            cell.imageView?.image = image
            cell.imageView?.tintColor = UIColor.blue
        } else {
            let image = UIImage(named: "tabbar_todos")!.withRenderingMode(.alwaysTemplate)
            cell.imageView?.image = image
            cell.imageView?.tintColor = UIColor.white
        }
        
        return cell
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        label.textColor = view.tintColor
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    //on click give the reward
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if  task[indexPath.row].deletion == "N" {
                let image = UIImage(named: "tabbar_todos")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.image = image
                cell.imageView?.tintColor = UIColor.blue
                if (task[indexPath.row].difficulty == 1){
                    account[0].money += 1;
                    Toast.short(message: "+1 Gold", success: "1", failer: "0")
                }
                else if (task[indexPath.row].difficulty == 2){
                    account[0].money += 3;
                    Toast.short(message: "+3 Gold", success: "1", failer: "0")
                }
                else{
                    account[0].money += 5;
                    Toast.short(message: "+5 Gold", success: "1", failer: "0")
                }
                task[indexPath.row].deletion = "Y"
            }
                
            else {
                let image = UIImage(named: "tabbar_todos")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.image = image
                cell.imageView?.tintColor = UIColor.white
                task[indexPath.row].deletion = "N"
                if (task[indexPath.row].difficulty == 1){
                    account[0].money -= 1;
                    Toast.short(message: "-1 Gold", success: "1", failer: "0")
                }
                else if (task[indexPath.row].difficulty == 2){
                    account[0].money -= 3;
                    Toast.short(message: "-1 Gold", success: "1", failer: "0")
                }
                else{
                    account[0].money -= 5;
                    Toast.short(message: "-5 Gold", success: "1", failer: "0")
                }
            }
            appDelegate.saveContext()
            self.fetchFromCoreData()
            self.tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            //TODO: edit the row at indexPath here
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            
            do{
                let test = try managedContext.fetch(fetchRequest)
                
                //setting global varibale so that the alert will show
                titles = self.task[indexPath.row].title!
                notes = self.task[indexPath.row].subtext!
                dates = self.task[indexPath.row].duedate! as NSDate
                difficulty = Int(self.task[indexPath.row].difficulty)
                row = indexPath.row
                
                //launch edit alert
                let customAlert1 = self.storyboard?.instantiateViewController(withIdentifier: "EditAlertID") as! CustomEdit
                customAlert1.providesPresentationContextTransitionStyle = true
                customAlert1.definesPresentationContext = true
                customAlert1.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                customAlert1.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                customAlert1.delegate = self as? CustomAlertViewDelegate
               
                self.present(customAlert1, animated: true, completion: nil)
                self.fetchFromCoreData()
                self.tableView.reloadData()
                
                do{
                    try managedContext.save()
                }
                catch{
                    print(error)
                }
            }
            catch{
                print(error)
            }
        }
        editAction.backgroundColor = .blue
        //deletion of core data
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            
            do{
                let test = try managedContext.fetch(fetchRequest)
                
                let objectToDelete = test[indexPath.row] as! NSManagedObject
                managedContext.delete(objectToDelete)
                
                do{
                    try managedContext.save()
                }
                catch{
                    print(error)
                }
            }
            catch{
                print(error)
            }
            self.task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
            appDelegate.saveContext()
            self.fetchFromCoreData()
            self.tableView.reloadData()
            
        }
        deleteAction.backgroundColor = .red
        
        return [editAction, deleteAction]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(request)
        } catch let error as NSError {
        }
        self.tableView.reloadData()
    }
    //adding to core data 
    @IBAction func btnAdd(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self as? CustomAlertViewDelegate
        self.present(customAlert, animated: true, completion: nil)
    }
}

