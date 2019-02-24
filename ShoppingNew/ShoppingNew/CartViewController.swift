//
//  CartViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 18/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import Foundation
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import Alamofire

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var shipProduct: UILabel!
    @IBOutlet weak var coutPrice: UILabel!
    @IBOutlet weak var allPrice: UILabel!
    @IBOutlet weak var PriceProduct: UILabel!

    @IBOutlet weak var NextButton: UIButton!
    var nameArray = [String]()
    var nameInt = [Int]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationController!.navigationBar.tintColor = UIColor(red: 76/255, green: 76/255, blue: 80/255, alpha: 1.0)
        
        NextButton.layer.cornerRadius = 5.0
        view2.layer.cornerRadius = 5.0
        tableView.layer.cornerRadius = 5.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = false
        tableView.reloadData()
        reloadSum()
       
        
    }
    
    func reloadSum() {
        
        var i = 0
        
        var sum = 0
        var ship = 0
        var fee = 0
        
        while i < appDelegate.OrderData.count {
            
            let price = Int(appDelegate.OrderData[i]["Pprice"]!)
            let amount = Int(appDelegate.OrderData[i]["Pamount"]!)
            sum = sum + (price! * amount!)
            i = i + 1
        }
        
        
        PriceProduct.text = "\(sum.delimiter) บาท"
        shipProduct.text = "\(ship.delimiter) บาท"
        coutPrice.text = "\(fee.delimiter) บาท"
        let sumAll = (sum-ship-fee)
        allPrice.text = "\(sumAll.delimiter) บาท"
        
        
        
    }
    
    
    //Post API
    func JsonPost(){
        
        print("Okk")
        
        let data: [String: Any] = [
            "cus_username": "Nontawat04",
            "cus_password": 12356,
            "cus_fname": "First",
            "cus_lname": "Second",
            "cus_phone" : "1911",
            "cus_email": "nontawat@gmail.com",
            "cus_picture": "nil",
            "cus_type_login": 1,
            "cus_active": 1,
            "status": true
            ]
        
        let urlString = "https://ubonmed.pandascoding.com/api/customer/add"
        
        Alamofire.request(urlString, method: .post, parameters: data ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
     
        tabBarController?.navigationItem.title? = "ตะกร้าสินค้า"
        
//        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
         self.tabBarController?.navigationItem.rightBarButtonItem = nil;
        
        
        print("ID \(AccessToken.current?.userId)")
        
        tableView.reloadData()
        reloadSum()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
       
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        TableHeight.constant = CGFloat(appDelegate.OrderData.count * 85)
        
        return appDelegate.OrderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderCell
        
        
        cell.nameProduct.text = appDelegate.OrderData[indexPath.item]["Pname"]!
        
        let price = Int(appDelegate.OrderData[indexPath.item]["Pprice"]!)
        cell.priceProduct.text = "\(price!.delimiter) บาท"
        cell.amountProduct.text = "\(appDelegate.OrderData[indexPath.item]["Pamount"]!)"
        
        let url = URL(string: "https://ubonmed.pandascoding.com/images/\(appDelegate.OrderData[indexPath.item]["Ppic"]!)")
        cell.imageProduct.kf.setImage(with: url)
        
        //cell.yourbutton.tag = indexPath.row;
        cell.BTplus.tag = indexPath.row
        cell.BTplus.addTarget(self, action: #selector(btPlus), for: .touchUpInside)
        cell.BTdown.tag = indexPath.row
        cell.BTdown.addTarget(self, action: #selector(btDown), for: .touchUpInside)
        cell.removeOrder.tag = indexPath.row
        cell.removeOrder.addTarget(self, action: #selector(btRemove), for: .touchUpInside)
        
        
        
        return cell
    }
    
    @objc func btPlus(sender: UIButton)
    {
        print("Pluss ta \(sender.tag)")
        
        var count = Int(appDelegate.OrderData[sender.tag]["Pamount"]!)
        appDelegate.OrderData[sender.tag]["Pamount"] = "\(count! + 1)"
        tableView.reloadData()
         reloadSum()
    }
    
    @objc func btDown(sender: UIButton)
    {
        print("Down \(sender.tag)")
        
        var count = Int(appDelegate.OrderData[sender.tag]["Pamount"]!)
        
        if count! == 1 {
            appDelegate.OrderData.remove(at: sender.tag)
        }else{
            appDelegate.OrderData[sender.tag]["Pamount"] = "\(count! - 1)"
        }
        
        tableView.reloadData()
         reloadSum()
        
        if appDelegate.OrderData.count == 0 {
            tabBarController?.selectedIndex = 0
        }
        
    }
    
    @objc func btRemove(sender: UIButton)
    {
        print("Remove \(sender.tag)")
        appDelegate.OrderData.remove(at: sender.tag)
        tableView.reloadData()
         reloadSum()
        
        if appDelegate.OrderData.count == 0 {
            tabBarController?.selectedIndex = 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }

}

