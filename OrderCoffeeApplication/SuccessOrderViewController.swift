//
//  SuccessOrderViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 26/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class SuccessOrderViewController: UIViewController {

    @IBOutlet weak var successLbl: UILabel!
    
    var databaseRef: DatabaseReference!
    var getShopID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        databaseRef = Database.database().reference()
        databaseRef.child("Shop").child(getShopID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.successLbl.text = "If you need to change order, please contact \(value?["PhoneNumber"] as? String ?? "")"
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
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
    
}
