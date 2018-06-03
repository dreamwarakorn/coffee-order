//
//  CustomizeViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 22/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CustomizeViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var coldButton: UIButton!
    @IBOutlet weak var frappeButton: UIButton!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var noSweetBtn: UIButton!
    @IBOutlet weak var lowSweetBtn: UIButton!
    @IBOutlet weak var midSweetBtn: UIButton!
    @IBOutlet weak var highSweetBtn: UIButton!
    @IBOutlet weak var noWipBtn: UIButton!
    @IBOutlet weak var yesWipBtn: UIButton!
    @IBOutlet weak var noSyrupBtn: UIButton!
    @IBOutlet weak var vanillaSyrupBtn: UIButton!
    @IBOutlet weak var caramelSyrupBtn: UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var sweetLbl: UILabel!
    @IBOutlet weak var whipLbl: UILabel!
    @IBOutlet weak var syrupLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var disFrappeButton: UILabel!
    @IBOutlet weak var disHotButton: UILabel!
    @IBOutlet weak var disColdButton: UILabel!
    @IBOutlet weak var disSweetnButton: UILabel!
    @IBOutlet weak var disSweetLButton: UILabel!
    @IBOutlet weak var disSweetMButton: UILabel!
    @IBOutlet weak var disSweetHButton: UILabel!
    @IBOutlet weak var disWhipnButton: UILabel!
    @IBOutlet weak var disWhipyButton: UILabel!
    @IBOutlet weak var disSyrupnButton: UILabel!
    @IBOutlet weak var disSyrupvButton: UILabel!
    @IBOutlet weak var disSyrupcButton: UILabel!
    
    var databaseRef: DatabaseReference!

    var orders: [NSManagedObject] = []
    var getItemName = String()
    var getDetail = String()
    var itemType = String()
    var sweet = String()
    var whip = String()
    var syrup = String()
    var getShopId = String()
    var getShopName = String()
    var getImage = UIImage()
    var qty = 1
    var gethPrice = String()
    var getcPrice = String()
    var getfPrice = String()
    
    var price = Int()
    var priceSelect = Int()
    var priceHot = Int()
    var priceCold = Int()
    var priceFrappe = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.nameLbl.text = getItemName
        self.detailLbl.text = getDetail
        self.priceLbl.text = "0 ฿"
        self.qtyLbl.text = "\(qty)"
        self.imgView.image = getImage
        
        navigationItem.title = "Customize"
        
        imgView.layer.cornerRadius = imgView.bounds.height / 2
        imgView.clipsToBounds = true
        
        //ตั้ง default ปุ่ม Disable
        disFrappeButton.isHidden = true
        disHotButton.isHidden = true
        disColdButton.isHidden = true
        disSweetnButton.isHidden = true
        disSweetLButton.isHidden = true
        disSweetMButton.isHidden = true
        disSweetHButton.isHidden = true
        disWhipnButton.isHidden = true
        disWhipyButton.isHidden = true
        disSyrupnButton.isHidden = true
        disSyrupvButton.isHidden = true
        disSyrupcButton.isHidden = true
        
        //แต่งปุ่ม Disable
        disFrappeButton.layer.masksToBounds = true
        disFrappeButton.layer.cornerRadius = 5.0
        disHotButton.layer.masksToBounds = true
        disHotButton.layer.cornerRadius = 5.0
        disColdButton.layer.masksToBounds = true
        disColdButton.layer.cornerRadius = 5.0
        disSweetnButton.layer.masksToBounds = true
        disSweetnButton.layer.cornerRadius = 5.0
        disSweetLButton.layer.masksToBounds = true
        disSweetLButton.layer.cornerRadius = 5.0
        disSweetMButton.layer.masksToBounds = true
        disSweetMButton.layer.cornerRadius = 5.0
        disSweetHButton.layer.masksToBounds = true
        disSweetHButton.layer.cornerRadius = 5.0
        disWhipnButton.layer.masksToBounds = true
        disWhipnButton.layer.cornerRadius = 5.0
        disWhipyButton.layer.masksToBounds = true
        disWhipyButton.layer.cornerRadius = 5.0
        disSyrupnButton.layer.masksToBounds = true
        disSyrupnButton.layer.cornerRadius = 5.0
        disSyrupvButton.layer.masksToBounds = true
        disSyrupvButton.layer.cornerRadius = 5.0
        disSyrupcButton.layer.masksToBounds = true
        disSyrupcButton.layer.cornerRadius = 5.0
        
        //แต่งปุ่มเพิ่ม-ลด จำนวนสินค้า
        plusButton.layer.cornerRadius = plusButton.bounds.height / 2
        plusButton.clipsToBounds = true
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.borderColor = UIColor.gray.cgColor
        minusButton.layer.cornerRadius = minusButton.bounds.height / 2
        minusButton.clipsToBounds = true
        minusButton.layer.borderWidth = 1.0
        minusButton.layer.borderColor = UIColor.gray.cgColor
        
        //แต่งปุ่มประแภทเครื่องดื่ม
        hotButton.layer.masksToBounds = true
        hotButton.layer.cornerRadius = 5.0
        coldButton.layer.masksToBounds = true
        coldButton.layer.cornerRadius = 5.0
        frappeButton.layer.masksToBounds = true
        frappeButton.layer.cornerRadius = 5.0
        
        //แต่งปุ่มระดับความหวาน
        noSweetBtn.layer.masksToBounds = true
        noSweetBtn.layer.cornerRadius = 5.0
        lowSweetBtn.layer.masksToBounds = true
        lowSweetBtn.layer.cornerRadius = 5.0
        midSweetBtn.layer.masksToBounds = true
        midSweetBtn.layer.cornerRadius = 5.0
        highSweetBtn.layer.masksToBounds = true
        highSweetBtn.layer.cornerRadius = 5.0
        
        //แต่งปุ่มวิปปิ้งครีม
        noWipBtn.layer.masksToBounds = true
        noWipBtn.layer.cornerRadius = 5.0
        yesWipBtn.layer.masksToBounds = true
        yesWipBtn.layer.cornerRadius = 5.0
        
        //แต่งปุ่มไซรัป
        noSyrupBtn.layer.masksToBounds = true
        noSyrupBtn.layer.cornerRadius = 5.0
        vanillaSyrupBtn.layer.masksToBounds = true
        vanillaSyrupBtn.layer.cornerRadius = 5.0
        caramelSyrupBtn.layer.masksToBounds = true
        caramelSyrupBtn.layer.cornerRadius = 5.0
        
        databaseRef = Database.database().reference()
        databaseRef.child("Product").child(getShopId).child(getItemName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let sweet = value?["OptionSweet"] as? String ?? ""
            let cream = value?["OptionCream"] as? String ?? ""
            let syrup = value?["OptionSyrup"] as? String ?? ""
            
            if(sweet != "open"){
                self.noSweetBtn.isHidden = true
                self.lowSweetBtn.isHidden = true
                self.midSweetBtn.isHidden = true
                self.highSweetBtn.isHidden = true
                //self.sweetLbl.isHidden = true
                self.disSweetnButton.isHidden = false
                self.disSweetLButton.isHidden = false
                self.disSweetMButton.isHidden = false
                self.disSweetHButton.isHidden = false
                self.sweet = "-"
            }
            if(cream != "open"){
                self.noWipBtn.isHidden = true
                self.yesWipBtn.isHidden = true
                //self.whipLbl.isHidden = true
                self.disWhipnButton.isHidden = false
                self.disWhipyButton.isHidden = false
                self.whip = "-"
            }
            if(syrup != "open"){
                self.noSyrupBtn.isHidden = true
                self.caramelSyrupBtn.isHidden = true
                self.vanillaSyrupBtn.isHidden = true
                //self.syrupLbl.isHidden = true
                self.disSyrupnButton.isHidden = false
                self.disSyrupcButton.isHidden = false
                self.disSyrupvButton.isHidden = false
                self.syrup = "-"
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //เช็คเงื่อนไขราคา
        if (gethPrice == ""){
            hotButton.isHidden = true
            disHotButton.isHidden = false
        }
        else
        {
            priceHot = Int(gethPrice)!
        }
        if (getcPrice == ""){
            coldButton.isHidden = true
            disColdButton.isHidden = false
        }
        else
        {
            priceCold = Int(getcPrice)!
        }
        if (getfPrice == ""){
            frappeButton.isHidden = true
            disFrappeButton.isHidden = false
        }
        else
        {
            priceFrappe = Int(getfPrice)!
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
    
    @IBAction func hotBtn(_ sender: Any) {
        hotButton.backgroundColor = UIColor(named: "Active")
        hotButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        coldButton.layer.backgroundColor = UIColor.white.cgColor
        coldButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        frappeButton.layer.backgroundColor = UIColor.white.cgColor
        frappeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        itemType = "Hot"
        priceLbl.text = gethPrice + "฿"
        price = priceHot
        priceSelect = priceHot
    }
    
    @IBAction func coldBtn(_ sender: Any) {
        coldButton.backgroundColor = UIColor(named: "Active")
        coldButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        hotButton.layer.backgroundColor = UIColor.white.cgColor
        hotButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        frappeButton.layer.backgroundColor = UIColor.white.cgColor
        frappeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        itemType = "Cold"
        priceLbl.text = getcPrice + "฿"
        price = priceCold
        priceSelect = priceCold
    }
    
    @IBAction func frappeBtn(_ sender: Any) {
        frappeButton.backgroundColor = UIColor(named: "Active")
        frappeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        coldButton.layer.backgroundColor = UIColor.white.cgColor
        coldButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        hotButton.layer.backgroundColor = UIColor.white.cgColor
        hotButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        itemType = "Frappe"
        priceLbl.text = getfPrice + "฿"
        price = priceFrappe
        priceSelect = priceFrappe
    }
    
    @IBAction func noSweetBtn(_ sender: Any) {
        noSweetBtn.backgroundColor = UIColor(named: "Active")
        noSweetBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        lowSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        lowSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        midSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        midSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        highSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        highSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        sweet = "no Sugar"
    }
    
    @IBAction func lowSweetBtn(_ sender: Any) {
        lowSweetBtn.backgroundColor = UIColor(named: "Active")
        lowSweetBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        noSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        noSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        midSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        midSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        highSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        highSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        sweet = "Low"
    }
    
    @IBAction func midSweetBtn(_ sender: Any) {
        midSweetBtn.backgroundColor = UIColor(named: "Active")
        midSweetBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        lowSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        lowSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        noSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        noSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        highSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        highSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        sweet = "Medium"
    }
    
    @IBAction func highSweetBtn(_ sender: Any) {
        highSweetBtn.backgroundColor = UIColor(named: "Active")
        highSweetBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        lowSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        lowSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        midSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        midSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        noSweetBtn.layer.backgroundColor = UIColor.white.cgColor
        noSweetBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        sweet = "High"
    }
    
    @IBAction func noWipBtn(_ sender: Any) {
        noWipBtn.backgroundColor = UIColor(named: "Active")
        noWipBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        yesWipBtn.layer.backgroundColor = UIColor.white.cgColor
        yesWipBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        whip = "No Whip cream"
    }
    
    @IBAction func yesWipBtn(_ sender: Any) {
        yesWipBtn.backgroundColor = UIColor(named: "Active")
        yesWipBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        noWipBtn.layer.backgroundColor = UIColor.white.cgColor
        noWipBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        whip = "Whipped cream"
    }
    
    @IBAction func noSyrupBtn(_ sender: Any) {
        noSyrupBtn.backgroundColor = UIColor(named: "Active")
        noSyrupBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        vanillaSyrupBtn.layer.backgroundColor = UIColor.white.cgColor
        vanillaSyrupBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        caramelSyrupBtn.layer.backgroundColor = UIColor.white.cgColor
        caramelSyrupBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        syrup = "No Syrup"
    }
    
    @IBAction func vanillaSyrupBtn(_ sender: Any) {
        vanillaSyrupBtn.backgroundColor = UIColor(named: "Active")
        vanillaSyrupBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        noSyrupBtn.layer.backgroundColor = UIColor.white.cgColor
        noSyrupBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        caramelSyrupBtn.layer.backgroundColor = UIColor.white.cgColor
        caramelSyrupBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        syrup = "Vanilla Syrup"
    }
    
    @IBAction func caramelSyrupBtn(_ sender: Any) {
        caramelSyrupBtn.backgroundColor = UIColor(named: "Active")
        caramelSyrupBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        vanillaSyrupBtn.layer.backgroundColor = UIColor.white.cgColor
        vanillaSyrupBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        noSyrupBtn.layer.backgroundColor = UIColor.white.cgColor
        noSyrupBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        syrup = "Caramel Syrup"
    }
    
    @IBAction func upQtyBtn(_ sender: Any) {
        price += priceSelect
        qty += 1
        self.qtyLbl.text = "\(qty)"
        self.priceLbl.text = "\(price) ฿"
    }
    
    @IBAction func downQtyBtn(_ sender: Any) {
        price -= priceSelect
        qty -= 1
        if qty == 0 {
            qty = 1
        }
        if price == 0 {
            price = priceSelect
        }
        self.qtyLbl.text = "\(qty)"
        self.priceLbl.text = "\(price) ฿"
    }
    
    @IBAction func addOrderBtn(_ sender: Any) {
        if itemType == "" || sweet == "" || whip == "" || syrup == "" {
            let errorAlert = UIAlertController(title: "Ooops!", message: "Please enter option.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            if sweet == "-" {
                sweet = ""
            }
            if whip == "-" {
                whip = ""
            }
            if syrup == "-" {
                syrup = ""
            }
            self.save(name: getItemName, type: itemType, qty: "\(qty)", sweet: sweet, whip: whip, syrup: syrup, price: "\(price)")
            self.performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    
    func save(name: String, type: String, qty: String, sweet: String, whip: String, syrup: String, price: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Order",
                                                in: managedContext)!
        
        let order = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        order.setValue(name, forKeyPath: "name")
        order.setValue(type, forKey: "type")
        order.setValue(qty, forKey: "quantity")
        order.setValue(sweet, forKey: "sweet")
        order.setValue(whip, forKey: "whip")
        order.setValue(syrup, forKey: "syrup")
        order.setValue(price, forKey: "price")
        
        do {
            try managedContext.save()
            orders.append(order)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //ส่งค่าไปยัง detailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OrderListViewController {
            destination.getOrder = orders
            destination.getID = getShopId
            destination.getName = getShopName
        }
    }
    
}
