//
//  InformationViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 17/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class InformationViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var matchIcon: UIImageView!
    
    var databaseRef: DatabaseReference!
    var userID = Auth.auth().currentUser?.uid
    var rootRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var selectedImage: UIImage?
    var array = [String]()
    var image: UIImage?
    var getMail = String()
    var getPass = String()
    var check = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        nameLbl.layer.borderWidth = 1.0
        nameLbl.layer.borderColor = UIColor.gray.cgColor
        phoneNumberLbl.layer.borderWidth = 1.0
        phoneNumberLbl.layer.borderColor = UIColor.gray.cgColor
        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        matchIcon.isHidden = false
        
        //ดึงค่าชื่อร้าน เวลาเปิด-ปิด และที่อยู่จาก Firebase
        databaseRef = Database.database().reference().child("Customer")
        databaseRef.observe(DataEventType.value, with: {(DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                for customers in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let customerObject = customers.value as? [String: AnyObject]
                    let customerName = customerObject?["Name"]
                    
                    self.array.append(customerName as! String)
                }
            }
        })
        
        nameTextField.addTarget(self, action: #selector(edited), for:.editingChanged)

    }
    
    @objc func edited() {
        if array.contains(nameTextField.text!) || nameTextField.text == "" {
            matchIcon.isHidden = false
            matchIcon.image = UIImage(named: "false")
            check = false
            print("Match")
        } else {
            matchIcon.isHidden = false
            matchIcon.image = UIImage(named: "true")
            check = true
            print("noMatch")
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
    
    @IBAction func saveProfileBtn(_ sender: Any) {
        
        if check == true && nameTextField.text != "" {
            if phoneNumberTextField.text?.range(of: "^[0-9]{2,3}-?[0-9]{3}-?[0-9]{3,4}$", options: .regularExpression) != nil {
                self.rootRef.child("Customer").child(userID!).child("Name").setValue(self.nameTextField.text!)
                self.rootRef.child("Customer").child(userID!).child("Phone").setValue(self.phoneNumberTextField.text!)
                self.rootRef.child("Customer").child(userID!).child("Email").setValue(getMail)
                self.rootRef.child("Customer").child(userID!).child("Password").setValue(getPass)
                
                if selectedImage == nil {
                    image = UIImage(named: "userProfile")!
                } else {
                    image = selectedImage!
                }
                
                let imageRef = storageRef.child("Customer").child(userID!).child("CustomerImage")
                if let profilePic = image, let imageData = UIImageJPEGRepresentation(profilePic, 0.1){
                    imageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                        if error != nil{
                            return
                        }
                        
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        self.rootRef.child("Customer").child(self.userID!).child("CustomerImage").setValue(profileImageUrl)
                    })
                }
                
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                let errorAlert = UIAlertController(title: "Signup error", message: "Error information, Please check phone number again.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        } else {
            let errorAlert = UIAlertController(title: "Signup error", message: "Error information, Please check the information again.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage = image
        profileImage.image = image
        profileImage.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
}

