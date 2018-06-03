//
//  OrderListViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 24/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import CoreData
import Firebase

struct Total {
    let price : String
}

class OrderListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseRef: DatabaseReference!
    var userID = Auth.auth().currentUser?.uid
    var rootRef = Database.database().reference()
    var getOrder: [NSManagedObject] = []
    var getID = String()
    var getName = String()
    var name = String()
    var image = String()
    var count = 0
    let pickerTime = UIDatePicker()
    var array = [Total]()
    var totalPrice = Int()
    var test = String()
    var num = Int()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickUpTextField: UITextField!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createDatePicker()
        
        databaseRef = Database.database().reference()
        databaseRef.child("Customer").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name = value?["Name"] as? String ?? ""
            self.image = value?["CustomerImage"] as? String ?? ""
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //รวมราคา
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let price = data.value(forKeyPath: "price") as? String
                let prices = Total(price: price!)
                array.append(prices)
            }
            let total = array.compactMap { Int($0.price) }
            totalPrice = total.reduce(0, +)
            totalPriceLbl.text = "Total  \(totalPrice) ฿"
        } catch {
            
            print("Failed")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ตกแต่ง Status bar
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor(named: "Status")!
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
        do {
            getOrder = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ListTableViewCell else {
            return UITableViewCell()
        }
        let list = getOrder[indexPath.row]
        cell.nameLbl?.text = list.value(forKeyPath: "name") as? String
        cell.detailLbl?.text = "\(list.value(forKeyPath: "type") ?? String()) \(list.value(forKeyPath: "sweet") ?? String()) \(list.value(forKeyPath: "whip") ?? String()) \(list.value(forKeyPath: "syrup") ?? String())"
        cell.qtyLbl?.text = "x" + (list.value(forKeyPath: "quantity") as? String)!
        cell.priceLbl?.text = (list.value(forKeyPath: "price") as? String)! + "฿"
        
        let productName = list.value(forKeyPath: "name") as? String
        databaseRef = Database.database().reference()
        databaseRef.child("Product").child(getID).child(productName!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if(value?["ProductImg"] != nil)
            {
                let productImage = value?["ProductImg"] as? String ?? ""
                
                let url = URL(string: productImage)
                let data = try? Data(contentsOf: url!)
                cell.imgView.image = UIImage(data: data!)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return cell
    }
    
    //Swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            self.test = self.getOrder[indexPath.row].value(forKeyPath: "price") as! String
            self.num = Int(self.test)!
            self.totalPrice = self.totalPrice - self.num
            context.delete(self.getOrder[indexPath.row])
            self.getOrder.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {
                // Error Handling
                // ...
            }
            self.tableView.reloadData()
            self.totalPriceLbl.text = "Total  \(self.totalPrice) ฿"
            completion(true)
        }
        action.image = UIImage(named: "delete.png")
        action.backgroundColor = .red
        
        return action
    }
    
    @IBAction func confirmOrderBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                count += 1
                let today = getTodayString() + " " + getTimeString()
                
                //Order
                self.rootRef.child("OrderDetail").child(getID).child(today).child("Item\(count)").child("ProductName").setValue(data.value(forKey: "name") as! String)
                self.rootRef.child("OrderDetail").child(getID).child(today).child("Item\(count)").child("ProductType").setValue(data.value(forKey: "type") as! String)
                self.rootRef.child("OrderDetail").child(getID).child(today).child("Item\(count)").child("TotalQty").setValue(data.value(forKey: "quantity") as! String)
                self.rootRef.child("OrderDetail").child(getID).child(today).child("Item\(count)").child("OptionSweet").setValue(data.value(forKey: "sweet") as! String)
                self.rootRef.child("OrderDetail").child(getID).child(today).child("Item\(count)").child("OptionCream").setValue(data.value(forKey: "whip") as! String)
                self.rootRef.child("OrderDetail").child(getID).child(today).child("Item\(count)").child("OptionSyrup").setValue(data.value(forKey: "syrup") as! String)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("Date").setValue(getTodayString())
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("OrderTimePick").setValue(self.pickUpTextField.text!)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("CustomerID").setValue(name)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("CustomerImg").setValue(image)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("ShopID").setValue(getID)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("Time").setValue(getTimeString())
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("TotalPrice").setValue("\(totalPrice)")
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("ProductNameShow1").setValue(data.value(forKey: "name") as! String)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("ProductTypeShow1").setValue(data.value(forKey: "type") as! String)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("TotalQtyShow1").setValue(data.value(forKey: "quantity") as! String)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("OptionSweetShow1").setValue(data.value(forKey: "sweet") as! String)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("OptionCreamShow1").setValue(data.value(forKey: "whip") as! String)
                self.rootRef.child("Order").child(getID).child(getTodayString()).child(getTimeString()).child("OptionSyrupShow1").setValue(data.value(forKey: "syrup") as! String)
                
                //OrderHistory
                self.rootRef.child("CustomerHistoryDetail").child(userID!).child(today).child("Item\(count)").child("ProductName").setValue(data.value(forKey: "name") as! String)
                self.rootRef.child("CustomerHistoryDetail").child(userID!).child(today).child("Item\(count)").child("ProductType").setValue(data.value(forKey: "type") as! String)
                self.rootRef.child("CustomerHistoryDetail").child(userID!).child(today).child("Item\(count)").child("TotalQty").setValue(data.value(forKey: "quantity") as! String)
                self.rootRef.child("CustomerHistoryDetail").child(userID!).child(today).child("Item\(count)").child("OptionSweet").setValue(data.value(forKey: "sweet") as! String)
                self.rootRef.child("CustomerHistoryDetail").child(userID!).child(today).child("Item\(count)").child("OptionCream").setValue(data.value(forKey: "whip") as! String)
                self.rootRef.child("CustomerHistoryDetail").child(userID!).child(today).child("Item\(count)").child("OptionSyrup").setValue(data.value(forKey: "syrup") as! String)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("Name").setValue(getName)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("Date").setValue(getTodayString())
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("Time").setValue(getTimeString())
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("ProductNameShow1").setValue(data.value(forKey: "name") as! String)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("ProductTypeShow1").setValue(data.value(forKey: "type") as! String)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("TotalQtyShow1").setValue(data.value(forKey: "quantity") as! String)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("OptionSweetShow1").setValue(data.value(forKey: "sweet") as! String)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("OptionCreamShow1").setValue(data.value(forKey: "whip") as! String)
                self.rootRef.child("CustomerHistory").child(userID!).child(today).child("OptionSyrupShow1").setValue(data.value(forKey: "syrup") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
        
        deleteCoreData()
        self.performSegue(withIdentifier: "goToSuccess", sender: self)
    }
    
    func deleteCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                context.delete(item)
            }
            
            // Save Changes
            try context.save()
            
        } catch {
            // Error Handling
            // ...
        }
    }
    
    //ส่งค่าไปยัง detailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSuccess" {
            let destination = segue.destination as? SuccessOrderViewController
            destination?.getShopID = getID
        } else if segue.identifier == "goToAdd" {
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnotherMenuViewController") as? UINavigationController,
                let DvC = controller.viewControllers.first as? AnotherMenuViewController {
                DvC.getID2 = getID
                DvC.getName2 = getName
                present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        let today_string = String(day!) + "-" + String(month!) + "-" + String(year!)
        
        return today_string
        
    }
    
    func getTimeString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour,.minute], from: date)
        
        let hour = components.hour
        let minute = components.minute
        
        let time_string = String(hour!)  + ":" + String(minute!)
        
        return time_string
        
    }
    
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        pickUpTextField.inputAccessoryView = toolbar
        pickUpTextField.inputView = pickerTime
        
        // format picker for date
        pickerTime.datePickerMode = .time
    }
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeString = formatter.string(from: pickerTime.date)
        
        pickUpTextField.text = "\(timeString)"
        self.view.endEditing(true)
    }
    
}
