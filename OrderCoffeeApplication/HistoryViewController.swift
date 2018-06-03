//
//  HistoryViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 3/5/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

struct History {
    let cusName: String
    let date: String
    let name: String
    let type: String
    let sweet: String
    let cream: String
    let syrup: String
    let qty: String
    let time: String
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    var userID = Auth.auth().currentUser?.uid
    var databaseRef: DatabaseReference!
    var historyList = [History]()
    var showMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideMenuConstraint.constant = -268
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        databaseRef = Database.database().reference().child("CustomerHistory").child(userID!)
        databaseRef.observe(DataEventType.value, with: {(DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.historyList.removeAll()
                
                for historys in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let historyObject = historys.value as? [String: AnyObject]
                    let customerName = historyObject?["Name"]
                    let historyDate = historyObject?["Date"]
                    let historytime = historyObject?["Time"]
                    let historyName = historyObject?["ProductNameShow1"]
                    let historyType = historyObject?["ProductTypeShow1"]
                    let historyQty = historyObject?["TotalQtyShow1"]
                    let historySweet = historyObject?["OptionSweetShow1"]
                    let historyCream = historyObject?["OptionCreamShow1"]
                    let historySyrup = historyObject?["OptionSyrupShow1"]
                
                    let history = History(cusName: (customerName as! String?)!, date: (historyDate as! String?)!, name: (historyName as! String?)!, type: (historyType as! String?)!, sweet: (historySweet as! String?)!, cream: (historyCream as! String?)!, syrup: (historySyrup as! String?)!, qty: (historyQty as! String?)!, time: (historytime as! String?)!)
                    self.historyList.append(history)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    //ตกแต่ง Status bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor(named: "Status")!
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        let history: History
        
        history = historyList[indexPath.row]
        
        cell.dateLbl.text = "Date  " + history.date
        cell.detailLbl.text = "Order list:  " + history.name + " " + history.type + " " + history.sweet + " " + history.cream + " " + history.syrup + " " + history.qty
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let history: History
        
        history = historyList[indexPath.row]
        DvC.getName = history.cusName
        DvC.getDate = history.date
        DvC.getTime = history.time
        self.navigationController?.pushViewController(DvC, animated: true)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        sideMenuConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        showMenu = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
    }
    
    @IBAction func orderHistoryBtn(_ sender: Any) {
        sideMenuConstraint.constant = -268
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        showMenu = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sideMenuConstraint.constant = -268
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        showMenu = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
