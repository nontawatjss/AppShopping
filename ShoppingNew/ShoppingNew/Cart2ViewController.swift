//
//  Cart2ViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 3/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class Cart2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableHieght: NSLayoutConstraint!
    @IBOutlet weak var EditAddress: UIButton!
    @IBOutlet weak var AddAddress: UIButton!
    
    @IBOutlet weak var AddressShow: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NextProcess: UIButton!
    @IBOutlet weak var allSumLabel: UILabel!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var statusAddress = false
    var AddressAllData = [[String:String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.clear
        
        navigationItem.title = "ข้อมูลในการจัดส่ง"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Apprear")

        tableView.reloadData()
        Customview()
        loadSum()
        showAddress()
        
       // checkAddress()
    
    }
    
    func Customview() {
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        
        AddAddress.layer.cornerRadius = 5.0
        AddAddress.layer.borderWidth = 1.0
        AddAddress.layer.borderColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        
        NextProcess.layer.cornerRadius = 5.0
    }
    
    func checkAddress() {
        
        loadAddress()
        
    }
    
    func showAddress(){
        
//        if statusAddress == true {
//            AddAddress.isHidden = true
//            AddAddress.isEnabled = false
//            NextProcess.isEnabled = true
//            NextProcess.backgroundColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
//
//
//            self.appDelegate.AddressUse = self.AddressAllData[0]
//
//
//            self.AddressShow.text = "\(self.appDelegate.AddressUse["Aline2"]!) \n\(self.appDelegate.AddressUse["Aline1"]!) \nตำบล \(self.appDelegate.AddressUse["Atambon"]!) อำเภอ \(self.appDelegate.AddressUse["Aamphoe"]!) จังหวัด \(self.appDelegate.AddressUse["Aprovince"]!) \(self.appDelegate.AddressUse["Acode"]!)"
//
//
//        }else{
//            NextProcess.isEnabled = false
//            self.AddressShow.text = ""
//
//        }
        
        if appDelegate.AddressUse.count == 0 {
            NextProcess.isEnabled = false
            AddAddress.isHidden = false
            AddAddress.isEnabled = true
            AddressShow.isHidden = true
            EditAddress.isHidden = true
        }else{
            NextProcess.isEnabled = true
            NextProcess.backgroundColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            AddAddress.isHidden = true
            AddAddress.isEnabled = false
            AddressShow.isHidden = false
             EditAddress.isHidden = false
            
            self.AddressShow.text = "\(self.appDelegate.UserDetail["fname"]!) \(self.appDelegate.UserDetail["lname"]!) \n\(self.appDelegate.AddressUse["Aline1"]!) \nตำบล \(self.appDelegate.AddressUse["Atambon"]!) อำเภอ \(self.appDelegate.AddressUse["Aamphoe"]!) จังหวัด \(self.appDelegate.AddressUse["Aprovince"]!) \(self.appDelegate.AddressUse["Acode"]!)"
        }
        
        
        
    }

    
    func loadAddress() {
        
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/address?customer_id=\(appDelegate.UserDetail["username"]!)")
        var dataProduct  = [[String:String]]()
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            var dataP = [[String:String]]()
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let status = (jsonObj!.value(forKey: "status")!) as! Bool
                
                self.statusAddress = status
                
                if status == true {
                    
                    
                    if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                        
                        
                        for dataList in dataArray{
                            
                            if let heroeDict = dataList as? NSDictionary {
                                
                               
                                
                                  let Aid = "\(heroeDict.value(forKey: "address_id")!)"
                                 let Aline1 = "\(heroeDict.value(forKey: "address_line1")!)"
                                 let Aline2 = "\(heroeDict.value(forKey: "address_line2")!)"
                                 let Atamboon = "\(heroeDict.value(forKey: "address_tambon")!)"
                                 let Aamphoe = "\(heroeDict.value(forKey: "address_amphoe")!)"
                                 let Aprovince = "\(heroeDict.value(forKey: "address_province")!)"
                                 let Acode = "\(heroeDict.value(forKey: "address_zipcode")!)"
                                 let Ausername = "\(heroeDict.value(forKey: "address_customer")!)"
                                
                                self.AddressAllData.append(["Aid": Aid,
                                                       "Aline1": Aline1,
                                                       "Aline2": Aline2,
                                                       "Atambon": Atamboon,
                                                       "Aamphoe": Aamphoe,
                                                       "Aprovince": Aprovince,
                                                       "Acode": Acode,
                                                       "Ausername": Ausername ])
                                
                            }
                        }
                    }
                }
 
                OperationQueue.main.addOperation({
                    
                
                    self.showAddress()
             
                })
            }
        }).resume()
        
    }
    
    func loadSum() {
        var i = 0
        var sum = 0
        while i < appDelegate.OrderData.count {
            sum = sum + (Int(appDelegate.OrderData[i]["Pprice"]!)! * Int(appDelegate.OrderData[i]["Pamount"]!)!)
            print("\(i)")
            
            i = i + 1
        }
        
        allSumLabel.text = "\(sum.delimiter) บาท"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        TableHieght.constant = CGFloat(appDelegate.OrderData.count * 85)
        
        return appDelegate.OrderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Order2Cell
        
        cell.NameP.text = appDelegate.OrderData[indexPath.item]["Pname"]!
        cell.AmountP.text = "จำนวน \(appDelegate.OrderData[indexPath.item]["Pamount"]!)"
        
        let c = Int(appDelegate.OrderData[indexPath.item]["Pamount"]!)
        let p = Int(appDelegate.OrderData[indexPath.item]["Pprice"]!)
        var cp = (p! * c!)
        cell.SumP.text = "\(cp.delimiter) บาท"
        
        let url = URL(string: "https://ubonmed.pandascoding.com/images/\(appDelegate.OrderData[indexPath.item]["Ppic"]!)")
        cell.imageCell.kf.setImage(with: url)
        
        return cell
    }
    

    @IBAction func NexPrecess(_ sender: Any) {
    }
    @IBAction func addAddress(_ sender: Any) {
        performSegue(withIdentifier: "goAddress", sender: self)
        
    }
    @IBAction func editAddress(_ sender: Any) {
    }
    
}
