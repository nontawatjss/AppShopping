//
//  DetailHistoryViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 6/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class DetailHistoryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var ScrollV: UIScrollView!
    
    
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var Status: UILabel!
    
    @IBOutlet weak var AllPrice: UILabel!
    @IBOutlet weak var DateIn: UILabel!
    @IBOutlet weak var TextAddress: UITextView!
    
    @IBOutlet weak var EmsCode: UILabel!
    
    
    @IBOutlet weak var heightView1: NSLayoutConstraint!
    
    @IBOutlet weak var NameEms: UILabel!
    
    @IBOutlet weak var Tableview: UITableView!
    
    @IBOutlet weak var ImageStatus: UIImageView!
    @IBOutlet weak var IdOrder: UILabel!
    
    
    var StatusName = ""
    var StatusID = 0
    var DateName = ""
    var AllPriceName = ""
    var AddressArea = ""
    var ImageS = ""
    
    var OrderHistory = [[String:String]]()
    
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tableview.delegate = self
        Tableview.dataSource = self
        View1.layer.cornerRadius = 5.0
        View2.layer.cornerRadius = 5.0
        Tableview.layer.cornerRadius = 5.0
        Tableview.separatorColor = UIColor.clear
        
        print("NAME \(appDelegate.HistorySelect)")
        
        navigationItem.title = "รายละเอียดการสั่งซื้อ"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        
        NameEms.isHidden = true
        EmsCode.isHidden = true
  
        getOrderHistory(orderid: "\(appDelegate.HistorySelect)")

    }
    
    func getOrderHistory(orderid:String){
        //creating a NSURL
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/order/all?username=\(appDelegate.UserDetail["username"]!)")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                
                
                if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                    
                    for dataList in dataArray{
                        
                        if let heroeDict = dataList as? NSDictionary {
                            
                            let order_id = "\(heroeDict.value(forKey: "order_id")!)"
                            
                            if orderid == order_id {
                                print("\(orderid) + \(order_id)")
                               
                                
                                let statusname = "\(heroeDict.value(forKey: "status_name")!)"
                                let totalPrice = "\(heroeDict.value(forKey: "order_total_price")!)"
                                let datein = "\(heroeDict.value(forKey: "order_date_in")!)"
                                let statusid = Int("\(heroeDict.value(forKey: "order_status")!)")!
                                
                                var imgStatus = ""
                                switch(statusid) {
                                case 1 :
                                    imgStatus = "icon_wait_check"
                                    self.heightView1.constant = self.heightView1.constant-46.0
                                    self.NameEms.isHidden = true
                                    self.EmsCode.isHidden = true
                                case 2 :
                                    imgStatus = "icon_wait_send"
                                     self.heightView1.constant = self.heightView1.constant-46.0
                                    self.NameEms.isHidden = true
                                    self.EmsCode.isHidden = true
                                case 3 :
                                    imgStatus = "icon_order_send"
                                    self.NameEms.isHidden = false
                                    self.EmsCode.isHidden = false
                                    
                                default:
                                    print("not all")
                                }
                                
                                print("SSSS \(statusid)")
                                
                                self.StatusName = statusname
                                self.AllPriceName = totalPrice
                                self.DateName = datein
                                self.ImageS = imgStatus
                                self.StatusID = statusid
                                
                                
                                //Address
                                if let dataA = heroeDict.value(forKey: "order_address_id") as? NSArray {
                                    
                                    
                                    for dataL in dataA{

                                        if let heroeD = dataL as? NSDictionary {

                                             let addressline1 = "\(heroeD.value(forKey: "address_line1")!)"
                                            
                                            
                                            self.AddressArea = "\(self.appDelegate.UserDetail["fname"]!) \(self.appDelegate.UserDetail["lname"]!) \n\(heroeD.value(forKey: "address_line1")!) \nตำบล \(heroeD.value(forKey: "address_tambon")!) อำเภอ \(heroeD.value(forKey: "address_amphoe")!) จังหวัด \(heroeD.value(forKey: "address_province")!) \(heroeD.value(forKey: "address_zipcode")!)"

                                        }

                                    }
                                    
                                }
                                
                                //ListProduce
                                if let dataB = heroeDict.value(forKey: "order_detail") as? NSArray {
                                    
                                    
                                    for dataL in dataB{
                                        
                                        if let heroeD = dataL as? NSDictionary {
                              
                                            
                                            
                                            var NameP = "\(heroeD.value(forKey: "prod_name")!)"
                                            
                                            let Chooseid = "\(heroeD.value(forKey: "detail_choose")!)"

                                            if Int(Chooseid) != 0 {
                                                
                                                NameP = NameP + " \(heroeD.value(forKey: "choose_name")!)"
                                              
                        
                                            }
                                            
                                            
                                            self.OrderHistory.append(["Pid": "\(heroeD.value(forKey: "detail_prod")!)",
                                                "Pname": "\(NameP)",
                                                "Pimage": "\(heroeD.value(forKey: "prod_main_picture")!)",
                                                "Pamount": "\(heroeD.value(forKey: "detail_amount")!)",
                                                "Ptotalprice": "\(heroeD.value(forKey: "detail_total_price")!)"
                                                ])
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                

                            } //End if
                            
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    
                    
                    self.Reload()
                   
                })
            }
        }).resume()
    }
    
    
    func Reload() {
        IdOrder.text = "คำสั่งซื้อ #\(appDelegate.HistorySelect)"
        Status.text = StatusName
        ImageStatus.image = UIImage(named: "\(ImageS)")
        if StatusID == 3 {
            
            Status.textColor = UIColor(red: 40/255, green: 208/255, blue: 148/255, alpha: 1.0)
            
        }else{
            Status.textColor = UIColor(red: 254/255, green: 196/255, blue: 59/255, alpha: 1.0)
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let string = "\(DateName)"
        if let date = dateFormatter.date(from: string) {
            print(date)   // "2015-06-30 17:30:36 +0000"
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated .
            
            let formateDate = dateFormatter.date(from: "\(date)")
            dateFormatter.dateFormat = "dd-MM-yyyy" // Output Formated
            
            //  print ("Print :\(dateFormatter.string(from: formateDate!))")//Print :02-02-2018
            
            DateIn.text = "\(dateFormatter.string(from: formateDate!))"
            
        }
        
        
        
        AllPrice.text = "\(AllPriceName) บาท"
        TextAddress.text = AddressArea
        Tableview.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryOrderCell
    
        let url = URL(string: "https://ubonmed.pandascoding.com/images/\(OrderHistory[indexPath.item]["Pimage"]!)")
        cell.ImageP.kf.setImage(with: url)
   
        cell.NameP.text = OrderHistory[indexPath.item]["Pname"]!
        cell.AmountP.text = "จำนวน \(OrderHistory[indexPath.item]["Pamount"]!)"
        cell.totalPrice.text = "\(OrderHistory[indexPath.item]["Ptotalprice"]!) บาท"
        
        cell.isUserInteractionEnabled = false
        return cell
    }


}
