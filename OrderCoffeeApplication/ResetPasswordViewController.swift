//
//  ResetPasswordViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 17/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
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
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
        let resetEmail = emailTextField.text
        Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: {(error) in
            if error != nil {
                let resetFieldAlert = UIAlertController(title: "Reset Failed", message: "Error: " + (error?.localizedDescription)!, preferredStyle: .alert)
                resetFieldAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFieldAlert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "goToSuccess", sender: self)
            }
        })
    }
    
}
