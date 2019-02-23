//
//  AddressViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 4/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var BTADD: UIButton!
    
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    var i = 0
    var areaAddress = ""
    @IBOutlet weak var tableView: UITableView!
    
      var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var checstatus = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.init(red: 244/255, green: 245/255, blue: 250/255, alpha: 1.0)
        tableView.separatorColor = UIColor.clear
        navigationItem.title = "ข้อมูลที่อยู่"
        BTADD.layer.cornerRadius = 5.0
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadAddress()
       
   
    }
    
    
    func loadAddress() {
    
         appDelegate.AddressData.removeAll()
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/address?customer_id=\(appDelegate.UserDetail["username"]!)")
     
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
      
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let status = (jsonObj!.value(forKey: "status")!) as! Bool
                
                if status == true {
                    
                    self.checstatus = status
                    
                    if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                        
                        
                        for dataList in dataArray{
                            
                            if let heroeDict = dataList as? NSDictionary {
                                
                                let Aid = "\(heroeDict.value(forKey: "address_id")!)"
                                let Aline1 = "\(heroeDict.value(forKey: "address_line1")!)"
                                let Aline2 = "\(heroeDict.value(forKey: "address_line2")!)"
                                let Atambon = "\(heroeDict.value(forKey: "address_tambon")!)"
                                let Aamphoe = "\(heroeDict.value(forKey: "address_amphoe")!)"
                                let Aprovince = "\(heroeDict.value(forKey: "address_province")!)"
                                let Azipcode = "\(heroeDict.value(forKey: "address_zipcode")!)"
                                let Acustomer = "\(heroeDict.value(forKey: "address_customer")!)"
                                
                                self.appDelegate.AddressData.append(["Aid": Aid,
                                                            "Aline1": Aline1,
                                                            "Aline2": Aline2,
                                                            "Atambon": Atambon,
                                                            "Aamphoe": Aamphoe,
                                                            "Aprovince": Aprovince,
                                                            "Acode": Azipcode,
                                                            "Ausername": Acustomer ])
                            }
                        }
                    }
                    
                }
                
                OperationQueue.main.addOperation({
                    
                    print("Address \(self.appDelegate.AddressData.count)")
                    
                    
                    self.i = self.appDelegate.AddressData.count
                    
                    self.tableView.reloadData()
                    
                    
                })
            }
        }).resume()
        
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        TableViewHeight.constant = ((tableView.rowHeight + 30.0) * CGFloat(self.appDelegate.AddressData.count)) + 15.0
        
        print("\(tableView.rowHeight)")
        
        return self.appDelegate.AddressData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
    
        headerView.backgroundColor = UIColor.clear
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Prompt-Medium", size: 16)
        headerLabel.textColor = UIColor.init(red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
        headerLabel.text = "ที่อยู่ \(section+1)"
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: tableView.frame.width - 180, y: 5, width: 200, height: 20)
        button.titleLabel?.font = UIFont(name: "Prompt-Medium", size: 16)
        button.tag = section
        button.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        button.setTitle("แก้ไขที่อยู่", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(BTEditAddress), for: .touchUpInside)
        
        var icon = UIImage(named: "icon_edit")!
        button.setImage(icon, for: .normal)
        button.imageView?.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
            
        headerView.addSubview(button)
        
    
        return headerView
        
    }
    
    
    @objc func BTEditAddress(sender:UIButton)
    {
        print("User : \(appDelegate.UserDetail["username"]!)")
        print("select \(sender.tag)")
        appDelegate.selectEditAddress = sender.tag
        performSegue(withIdentifier: "goEdit", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdressCell
            
            cell.TExtAdress.text =  "\(appDelegate.UserDetail["fname"]!) \(appDelegate.UserDetail["lname"]!) \n\(appDelegate.AddressData[indexPath.section]["Aline1"]!) \nตำบล \(appDelegate.AddressData[indexPath.section]["Atambon"]!) อำเภอ \(appDelegate.AddressData[indexPath.section]["Aamphoe"]!) จังหวัด \(appDelegate.AddressData[indexPath.section]["Aprovince"]!) \(appDelegate.AddressData[indexPath.section]["Acode"]!)"
            
        
            
            print("ISSS \(appDelegate.AddressData[indexPath.section]["Aline1"]!)")
            
            
            cell.TExtAdress.isEditable = false
            
        
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor
            cell.backgroundColor = UIColor.white
        
        
        
        
        return cell
    }
    
    @objc func btAddress(sender: UIButton)
    {
        print("Pluss ta \(sender.tag)")
        
        performSegue(withIdentifier: "goAddAddress", sender: self)
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.item)")
     
            
              self.navigationController?.popViewController(animated: true)
             appDelegate.AddressUse = appDelegate.AddressData[indexPath.section]
        
  
    }

}
