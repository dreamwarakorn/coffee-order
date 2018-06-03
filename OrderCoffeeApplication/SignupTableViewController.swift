//
//  SignupTableViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 17/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class SignupTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //แต่ง Status bar
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    @IBAction func createAccountBtn(_ sender: Any) {
        if confirmpasswordTextField.text == passwordTextField.text{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if error != nil {
                    let signuperrorAlert = UIAlertController(title: "Signup error", message: (error?.localizedDescription)! + "Please try again later", preferredStyle: .alert)
                    signuperrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(signuperrorAlert, animated: true, completion: nil)
                    return
                }
                self.login()
            })
        } else {
            let passwordNotMatchAlert = UIAlertController(title: "Oops!", message: "Your passwords do not match. Please re-enter your password again", preferredStyle: .alert)
            passwordNotMatchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                self.passwordTextField.text = ""
                self.confirmpasswordTextField.text = ""
            }))
            present(passwordNotMatchAlert, animated: true, completion: nil)
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            if error != nil {
                let loginerrorAlert = UIAlertController(title: "Login error", message: (error?.localizedDescription)! + "Please try again.", preferredStyle: .alert)
                loginerrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginerrorAlert, animated: true, completion: nil)
                return
            }
            
            else {
                
                self.performSegue(withIdentifier: "goToInformation", sender: self)
            }
        }
    }
    
    //ส่งค่าไปยัง detailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InformationViewController {
            destination.getMail = self.emailTextField.text!
            destination.getPass = self.passwordTextField.text!
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmpasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
