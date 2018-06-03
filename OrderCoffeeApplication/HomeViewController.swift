//
//  HomeViewController.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 19/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var databaseRef: DatabaseReference!

    var shopList = [Shop]()
    var filteredShop = [Shop]()
    let searchController = UISearchController(searchResultsController: nil)
    var showMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        sideMenuConstraint.constant = -268
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search shop by name"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], for: .normal)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
        //ดึงค่าชื่อร้าน เวลาเปิด-ปิด และที่อยู่จาก Firebase
        databaseRef = Database.database().reference().child("Shop")
        databaseRef.observe(DataEventType.value, with: {(DataSnapshot) in
            if DataSnapshot.childrenCount > 0 {
                self.shopList.removeAll()
                
                for shops in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let shopObject = shops.value as? [String: AnyObject]
                    let shopName = shopObject?["ShopName"]
                    let shopAddress = shopObject?["Address"]
                    let shopProvince = shopObject?["Province"]
                    let shopDistrict = shopObject?["District"]
                    let shopZipcode = shopObject?["ZipCode"]
                    let shopOpen = shopObject?["OpenTime"]
                    let shopClose = shopObject?["CloseTime"]
                    let shopID = shopObject?["ShopID"]
                    let shopImage = shopObject?["ShopImageLogo"]
                    
                    let shop = Shop(name: (shopName as! String?)!, address: (shopAddress as! String?)!, province: (shopProvince as! String?)!, district: (shopDistrict as! String?)!, zipcode: (shopZipcode as! String?)!, open: (shopOpen as! String?)!, close: (shopClose as! String?)!, id: (shopID as! String?)!, image: (shopImage as! String?)!)
                    
                    self.shopList.append(shop)
                }
                self.activity.stopAnimating()
                self.shopList.sort(by: {$0.name < $1.name})
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
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredShop.count, of: shopList.count)
            return filteredShop.count
        }
        
        searchFooter.setNotFiltering()
        return shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return UITableViewCell()
        }
        let shop: Shop
        if isFiltering() {
            shop = filteredShop[indexPath.row]
        } else {
            shop = shopList[indexPath.row]
        }
        cell.nameLbl!.text = shop.name
        cell.addressLbl!.text = "\(shop.address) \(shop.district) \(shop.province) \(shop.zipcode)"
        cell.timeLbl!.text = "Open \(shop.open) - \(shop.close)"
        
        let url = URL(string: shop.image)
        let data = try? Data(contentsOf: url!)
        cell.imgView!.image = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let shop: Shop
        if isFiltering() {
            shop = filteredShop[indexPath.row]
        } else {
            shop = shopList[indexPath.row]
        }
        DvC.getName = shop.name
        DvC.getID = shop.id
        self.navigationController?.pushViewController(DvC, animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredShop = shopList.filter({( shop : Shop) -> Bool in
                return shop.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
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
    
    @IBAction func homeBtn(_ sender: Any) {
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

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

struct Shop {
    let name : String
    let address : String
    let province : String
    let district : String
    let zipcode : String
    let open : String
    let close : String
    let id : String
    let image : String
}
