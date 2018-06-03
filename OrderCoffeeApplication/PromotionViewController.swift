//
//  PromotionViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 29/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class PromotionViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var blankView: UIView!
    
    var databaseRef: DatabaseReference!
    var shopId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Promotion"
        blankView.isHidden = true
        
        databaseRef = Database.database().reference()
        databaseRef.child("Shop").child(shopId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.detailLbl.text = value?["PromotionDetail"] as? String ?? ""
            
            if(value?["PromotionImg"] != nil)
            {
                let promotionImage = value?["PromotionImg"] as? String ?? ""
                
                let url = URL(string: promotionImage)
                let data = try? Data(contentsOf: url!)
                self.imgView.image = UIImage(data: data!)
            }
            
            if self.detailLbl.text == "" {
                self.blankView.isHidden = false
                print("empty")
            } else {
                self.aivLoading.stopAnimating()
            }
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
