//
//  MenuViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 20/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

struct Item {
    let name : String
    let detail : String
    let image : String
    let hprice : String
    let cprice : String
    let fprice : String
}

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var blankView: UIView!
    
    var databaseRef: DatabaseReference!
    var getName = String()
    var getID = String()
    var itemList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        blankView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationItem.title = getName
        
        //ดึงค่าชื่อสินค้าจาก Firebase
        databaseRef = Database.database().reference().child("Product").child(getID)
        databaseRef.observe(DataEventType.value, with: {(DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.itemList.removeAll()
                
                for items in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let itemObject = items.value as? [String: AnyObject]
                    let itemName = itemObject?["ProductName"]
                    let itemDetail = itemObject?["ProductDetail"]
                    let itemImage = itemObject?["ProductImg"]
                    let priceHot = itemObject?["ProductHotPrice"]
                    let priceCold = itemObject?["ProductColdPrice"]
                    let priceFrappe = itemObject?["ProductFrappePrice"]
                    
                    let item = Item(name: (itemName as! String?)!, detail: (itemDetail as! String?)!, image: (itemImage as! String?)!, hprice: (priceHot as! String?)!, cprice: (priceCold as! String?)!, fprice: (priceFrappe as! String?)!)
                    self.itemList.append(item)
                }
            }
            if self.itemList.isEmpty {
                self.blankView.isHidden = false
                print("empty")
            } else {
                self.itemList.sort(by: {$0.name < $1.name})
                self.aivLoading.stopAnimating()
                self.collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let item: Item
        item = itemList[indexPath.item]
        cell.itemLbl.text = item.name
        
        let url = URL(string: item.image)
        let data = try? Data(contentsOf: url!)
        cell.itemImageView!.image = UIImage(data: data!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "CustomizeViewController") as! CustomizeViewController
        
        let item: Item
        item = itemList[indexPath.item]
        
        DvC.getItemName = item.name
        DvC.getDetail = item.detail
        DvC.getShopId = getID
        DvC.getShopName = getName
        DvC.gethPrice = item.hprice
        DvC.getcPrice = item.cprice
        DvC.getfPrice = item.fprice
        
        let url = URL(string: item.image)
        let data = try? Data(contentsOf: url!)
        DvC.getImage = UIImage(data: data!)!
        
        self.navigationController?.pushViewController(DvC, animated: true)
    }
    
    //ส่งค่าไปยัง detailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PromotionViewController {
            destination.shopId = getID
        }
    }

}
