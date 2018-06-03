//
//  LoginTableViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 17/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    //var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
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
        return 2
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {(user, error) in
            if error != nil {
                let loginerrorAlert = UIAlertController(title: "Login error", message: (error?.localizedDescription)! + "Please try again.", preferredStyle: .alert)
                loginerrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginerrorAlert, animated: true, completion: nil)
                return
            } else {
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                let DvC = Storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(DvC, animated: true)
            }
        }
    }
    
    @IBAction func FBLoginBtn(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self) {(result) in
            switch result {
            case .success:
                let accessToken = AccessToken.current
                guard let accessTokenString = accessToken?.authenticationToken else {return}
                
                let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                Auth.auth().signIn(with: credentials, completion: {(user, error) in
                    if error != nil{
                        print("Something went wrong with user: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    
                    let user = Auth.auth().currentUser
                    self.databaseRef.child("Customer").child((user?.uid)!).child("Email").setValue(user?.email)
                    self.databaseRef.child("Customer").child((user?.uid)!).child("Name").setValue(user?.displayName)
                    if(FBSDKAccessToken.current() != nil)
                    {
                        //print permissions, such as public_profile
                        print(FBSDKAccessToken.current().permissions)
                        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id"])
                        let connection = FBSDKGraphRequestConnection()
                        
                        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                            
                            let data = result as! [String : AnyObject]
                            let FBid = data["id"] as? String
                            let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                            let image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                            
                            let imageRef = self.storageRef.child("Customer").child((user?.uid)!).child("CustomerImage")
                            if let profilePic = image, let imageData = UIImageJPEGRepresentation(profilePic, 0.1){
                                imageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                                    if error != nil{
                                        return
                                    }
                                    
                                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                                    self.databaseRef.child("Customer").child((user?.uid)!).child("CustomerImage").setValue(profileImageUrl)
                                })
                            }
                        })
                        connection.start()
                    }
                    
                    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let DvC = Storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(DvC, animated: true)
                })
                
            default:
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    

}
