//
//  SettingViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 30/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var databaseRef: DatabaseReference!
    var rootRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var userID = Auth.auth().currentUser?.uid
    var selectedImage: UIImage?
    var showMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideMenuConstraint.constant = -268
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.clipsToBounds = true
        //แต่ง Label
        nameLbl.layer.borderWidth = 1.0
        nameLbl.layer.borderColor = UIColor.gray.cgColor
        phoneLbl.layer.borderWidth = 1.0
        phoneLbl.layer.borderColor = UIColor.gray.cgColor
        
        databaseRef = Database.database().reference()
        databaseRef.child("Customer").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.nameTextField.text = value?["Name"] as? String ?? ""
            self.phoneTextField.text = value?["Phone"] as? String ?? ""
            
            if(value?["CustomerImage"] != nil)
            {
                let customerImage = value?["CustomerImage"] as? String ?? ""
                
                let url = URL(string: customerImage)
                let data = try? Data(contentsOf: url!)
                self.imageView.image = UIImage(data: data!)
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
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if phoneTextField.text?.range(of: "^[0-9]{2,3}-?[0-9]{3}-?[0-9]{3,4}$", options: .regularExpression) != nil {
            self.rootRef.child("Customer").child(userID!).child("Name").setValue(self.nameTextField.text!)
            self.rootRef.child("Customer").child(userID!).child("Phone").setValue(self.phoneTextField.text!)
            
            let imageRef = storageRef.child("Customer").child(userID!).child("CustomerImage")
            if let itemPic = self.selectedImage, let imageData = UIImageJPEGRepresentation(itemPic, 0.1){
                imageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        return
                    }
                    
                    let customerImageUrl = metadata?.downloadURL()?.absoluteString
                    self.rootRef.child("Customer").child(self.userID!).child("CustomerImage").setValue(customerImageUrl)
                })
            }
            //แจ้งเตือน
            let saveFieldAlert = UIAlertController(title: "Save", message: "Success", preferredStyle: .alert)
            saveFieldAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(saveFieldAlert, animated: true, completion: nil)
        } else {
            let errorAlert = UIAlertController(title: "Oops!", message: "Error information, Please check phone number again.", preferredStyle: .alert)
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
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        sideMenuConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        showMenu = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
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
    
    @IBAction func settingBtn(_ sender: Any) {
        sideMenuConstraint.constant = -268
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        showMenu = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sideMenuConstraint.constant = -268
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        showMenu = false
    }
    
}
