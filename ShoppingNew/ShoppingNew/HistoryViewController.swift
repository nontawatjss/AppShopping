//
//  HistoryViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 6/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
     var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var SBar: UISearchBar!
    
     var OrderList = [[String:String]]()
    
    var HistoryFilter = [String]()
    var dataHistory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "ประวัติการสั่งซื้อ"
        tableView.delegate = self
        tableView.dataSource = self
        SBar.delegate = self
        getOrderHistory()
       
    }

    
    func getOrderHistory(){
        //creating a NSURL
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/order/all?username=\(appDelegate.UserDetail["username"]!)")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                

                
                if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                    
                    
                    for dataList in dataArray{
                        
                        if let heroeDict = dataList as? NSDictionary {
                            
                            
                            // print("name \(heroeDict.value(forKey: "bank_name")!)")
                            let order_id = "\(heroeDict.value(forKey: "order_id")!)"
                            let order_date_in = "\(heroeDict.value(forKey: "order_date_in")!)"
                            let order_total_price = "\(heroeDict.value(forKey: "order_total_price")!)"
                            let status_name = "\(heroeDict.value(forKey: "status_name")!)"
                             let imgStatus = "\(heroeDict.value(forKey: "order_status")!)"
                            
                            self.OrderList.append(["order_id" : order_id,
                                                   "order_date_in": order_date_in,
                                                   "order_total_price": order_total_price,
                                                   "status_name": status_name,
                                                   "order_status": imgStatus
                                ])
                            
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    
//                    print("ISSS \(self.OrderList.count)")
//                    self.tableView.reloadData()
                    
                    self.reloadHistoryFilter()
                })
            }
        }).resume()
    }
    
    func reloadHistoryFilter(){
        
        SBar.text = ""
        print("LoadHistoryFilter")
        
     
        dataHistory.removeAll()
        HistoryFilter.removeAll()
        print("CO \(OrderList.count)")
        
        var i = 0
        while i < OrderList.count {
            
  
            HistoryFilter.append(OrderList[i]["order_id"]!)
            i = i + 1
        }
        
        dataHistory = HistoryFilter
        
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear

        var i = 0
        var id = 0
        while i < dataHistory.count {
            
            if HistoryFilter[section] == dataHistory[i]{
             
                id = i
            }
            
            i = i + 1
        }
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Prompt-Medium", size: 16)
        headerLabel.textColor = UIColor.init(red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
        headerLabel.text = "คำสั่งซื้อ #\(OrderList[id]["order_id"]!)"
        headerLabel.sizeToFit()
        vw.addSubview(headerLabel)
        
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: tableView.frame.width - 90, y: 0, width: 100, height: tableView.bounds.size.height)
        button.titleLabel?.font = UIFont(name: "Prompt-Medium", size: 14)
        button.tintColor = UIColor.init(red: 23/255, green: 172/255, blue: 230/255, alpha: 1.0)
       
        button.tag = section
        button.setTitle("ดูรายละเอียด", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(BTShowDetail), for: .touchUpInside)
         button.sizeToFit()
        vw.addSubview(button)
       
       // print("SEction \(section)")
        return vw
    }
    
    @objc func BTShowDetail(sender:UIButton)
    {
        var i = 0
        var id = 0
        while i < dataHistory.count {
            
            if HistoryFilter[sender.tag] == dataHistory[i]{
              
                id = i
            }
            
            i = i + 1
        }
        
      //  print("buttonClicked \(id)")
        appDelegate.HistorySelect = "\(OrderList[id]["order_id"]!)"
        performSegue(withIdentifier: "goDetail", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HistoryFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryCell
        
        
        var i = 0
        var id = 0
        while i < dataHistory.count {
            
            if HistoryFilter[indexPath.section] == dataHistory[i]{
                print(HistoryFilter[indexPath.section])
                id = i
            }
            
            i = i + 1
        }
        
       // print("sec \(indexPath.section)  \(indexPath.item) \(OrderList[id]["order_id"]!)")


       
        cell.Status.text = "\(OrderList[id]["status_name"]!)"
        
        let imageID = Int(OrderList[id]["order_status"]!)!
        switch imageID {
        case 1 :
            cell.ImgStatus.image = UIImage(named: "icon_wait_check")
        case 2 :
            cell.ImgStatus.image = UIImage(named: "icon_wait_send")
        case 3 :
            cell.ImgStatus.image = UIImage(named: "icon_order_send")
        default:
            print("not All")
        }
        

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let string = "\(OrderList[id]["order_date_in"]!)"
        if let date = dateFormatter.date(from: string) {
            //print(date)   // "2015-06-30 17:30:36 +0000"
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated .
            
            let formateDate = dateFormatter.date(from: "\(date)")
            dateFormatter.dateFormat = "dd-MM-yyyy" // Output Formated
            
          //  print ("Print :\(dateFormatter.string(from: formateDate!))")//Print :02-02-2018
            
            cell.DateOrder.text = "\(dateFormatter.string(from: formateDate!))"
            

        }
        
     //  print(OrderList[indexPath.section]["order_date_in"]!)
        
        cell.AllPrice.text = "\(OrderList[id]["order_total_price"]!) บาท"
        
        
        cell.layer.cornerRadius = 10.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       // print(section)
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print(indexPath.section)
        
        var i = 0
        var id = 0
        while i < dataHistory.count {

            if HistoryFilter[indexPath.section] == dataHistory[i]{

                id = i
            }

            i = i + 1
        }

        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.white
        }
        
       // print("buttonClicked \(id)")
        appDelegate.HistorySelect = "\(OrderList[id]["order_id"]!)"
        performSegue(withIdentifier: "goDetail", sender: nil)
        
    }
    
    
    //update search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        HistoryFilter = searchText.isEmpty ? dataHistory : dataHistory.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        print(HistoryFilter.count)
        print("data \(dataHistory)")
        print("fil \(HistoryFilter)")
        tableView.reloadData()
    }
    

}


