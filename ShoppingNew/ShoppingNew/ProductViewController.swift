//
//  ProductViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 22/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var label:UILabel!
    var rightButton:UIButton!
    var bgCart:UIImage!
    
    var ProductFilter = [String]()
    var dataProduct = [String]()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.title = "รายการสินค้า"
        print("รายการสินค้า")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1)
    
         view.backgroundColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1)
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""

        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        // Add it to the view where you want it to appear
        view.addSubview(activityIndicator)
        
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds
        
        getProduct(i: appDelegate.SelectCat)
        
        addCartIcon(i: appDelegate.OrderData.count)
    }
    
    func addCartIcon(i:Int){
        
        // badge label
        label = UILabel(frame: CGRect(x: 20, y: -6, width: 18, height: 18))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "SukhumvitSet-Bold", size: 13)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        label.text = "\(i)"
        
        // button
        self.rightButton = UIButton(type: UIButton.ButtonType.system)
        self.rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.rightButton.setImage(UIImage(named: "cart5"), for: .normal)
        self.rightButton.tintColor = UIColor(red: 76/255, green: 76/255, blue: 80/255, alpha: 1.0)
        self.rightButton.addTarget(self, action: #selector(pluscount), for: .touchUpInside)
        self.rightButton.addSubview(label)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProductFilter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        
       // NotificationCenter.default.post(name: Notification.Name("addCarticon"), object: nil)
    }
    
    
    @objc  func pluscount() {
        
        if appDelegate.OrderData.count == 0 {
            self.view.makeToast("ไม่มีสินค้าในตะกร้า", duration: 0.5, position: .bottom)
            
        }else {
            self.navigationController?.popToRootViewController(animated: true)
            appDelegate.AccessOpen = true
        }
        
        

    }
    
    
    func getProduct(i:Int) {
        //creating a NSURL
        appDelegate.ProductData.removeAll()
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/product/all?categoty_id=\(i)")
        var dataProduct  = [[String:String]]()
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            var dataP = [[String:String]]()
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //  let status = (jsonObj!.value(forKey: "status")!) as! Int
                
                
                if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                    
                    
                    for dataList in dataArray{
                        
                        if let heroeDict = dataList as? NSDictionary {
                            
                            let Pid = "\(heroeDict.value(forKey: "prod_id")!)"
                            let Pname = "\(heroeDict.value(forKey: "prod_name")!)"
                            let Pdescription = "\(heroeDict.value(forKey: "prod_description")!)"
                            let Ppic = "\(heroeDict.value(forKey: "prod_main_picture")!)"
                            let Pprice = "\(heroeDict.value(forKey: "prod_price")!)"
                            let Pcategory = "\(heroeDict.value(forKey: "prod_category")!)"
                            let Pchoose = "\(heroeDict.value(forKey: "prod_choose")!)"
                            let Pshipfee = "\(heroeDict.value(forKey: "cat_ship_fee")!)"

                            
                            self.appDelegate.ProductData.append(["Pid": Pid,
                                          "Pname": Pname,
                                          "Pdescription": Pdescription,
                                          "Ppic": Ppic,
                                          "Pprice": Pprice,
                                          "Pcategory": Pcategory,
                                          "Pchoose": Pchoose,
                                          "Pshipfee": Pshipfee])
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    
                    self.loadProductFilter()
                })
            }
        }).resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
        
    
        
        
        var i = 0
        var Proid = 0
        while i < dataProduct.count {
            if  ProductFilter[indexPath.item] == appDelegate.ProductData[i]["Pname"]! {
                Proid = i
            }
            i = i + 1
        }
        
        
        var item = appDelegate.ProductData[Proid]
        let url = URL(string: "https://ubonmed.pandascoding.com/images/\(item["Ppic"]!)")
        cell.ImageCell.kf.setImage(with: url)
        
        cell.ImageCell.layer.masksToBounds = true
        cell.ImageCell.layer.cornerRadius = 5.0

        
       
        cell.NameLabel.text = "\(item["Pname"]!)"
        
        
        let price = Int(item["Pprice"]!)
        
        cell.PriceLabel.text = "\(price!.delimiter) บาท"
        
        var Amount = 0
        var j = 0
        while j < appDelegate.OrderData.count {
            if appDelegate.OrderData[j]["Pname"] == ProductFilter[indexPath.item]{
                
               // print("\(appDelegate.OrderData[j]["Pname"]!) \(appDelegate.OrderData[j]["Pamount"]!)")
                Amount = Int(appDelegate.OrderData[j]["Pamount"]!)!
                
            }
            j = j + 1
        }
        
        cell.AmountLabel.text = "\(Amount)"
        
        
        cell.DeleteBT.tag = indexPath.item
        cell.DeleteBT.addTarget(self, action: #selector(deleteBT), for: .touchUpInside)
        
        
        cell.PlusBT.tag = indexPath.item
        cell.PlusBT.addTarget(self, action: #selector(addBT), for: .touchUpInside)
        cell.backgroundColor = UIColor.white
        
        
        cell.layer.borderWidth = 5;
        cell.layer.borderColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor
        cell.layer.cornerRadius = 10.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var i = 0
        while i < dataProduct.count {
            if ProductFilter[indexPath.item] == dataProduct[i] {
                appDelegate.SelectProduct = i
                print("Name \(ProductFilter[indexPath.item])")
            }
            i = i + 1
        }
        
        
        performSegue(withIdentifier: "goProductDetail", sender: nil)
        print("select \(appDelegate.SelectProduct)")
    }
    
    
    
    //update search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        ProductFilter = searchText.isEmpty ? dataProduct : dataProduct.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        print(ProductFilter)
        
        tableView.reloadData()
    }
   
    func loadProductFilter() {
        
        searchBar.text = ""
        print("LoadProductFilter")
        
        dataProduct.removeAll()
        ProductFilter.removeAll()
        print("CO \(appDelegate.ProductData.count)")
        
        var i = 0
        while i < appDelegate.ProductData.count {
            
 
            ProductFilter.append(appDelegate.ProductData[i]["Pname"]!)
            i = i + 1
        }
        
        
        
        dataProduct = ProductFilter
        
        tableView.reloadData()
        
    }
    
    
    @objc func deleteBT(sender: UIButton)
    {
        //print("D \(sender.tag)")

        var i = 0
        var check =  false
        var selectI = 0
        var amount = 0
        
        //Check All Product
        while i < appDelegate.ProductData.count {
            if ProductFilter[sender.tag] == appDelegate.ProductData[i]["Pname"]! {
                
                
                // print("\(ProductFilter[sender.tag]) = \(appDelegate.ProductData[i]["Pname"]!)")
                
                selectI = i
                var j = 0
                
                while j < appDelegate.OrderData.count {
                    if "\(appDelegate.OrderData[j]["Pname"]!)" == ProductFilter[sender.tag] {
                        
                        check = true
                       //print("\(appDelegate.OrderData[j]["Pamount"]!)")
                        amount = Int(appDelegate.OrderData[j]["Pamount"]!)!
                        selectI = j
                    }else{
                        
                        
                    }
                    
                    
                    j = j + 1
                }
                
                
            }
            i = i + 1
        }
        
        if check == true {

            if amount == 1 {
                appDelegate.OrderData.remove(at: selectI)
                addCartIcon(i: appDelegate.OrderData.count)
            }else{
                let c = Int(appDelegate.OrderData[selectI]["Pamount"]!)!
                appDelegate.OrderData[selectI]["Pamount"] = "\(c-1)"
            }
            
        }else{
            //print(false)
        }
        
        tableView.reloadData()
        
        
   }
    
    @objc func addBT(sender: UIButton)
    {
        var i = 0
        var check =  false
        var selectI = 0
        
        //Check All Product
        while i < appDelegate.ProductData.count {
            if ProductFilter[sender.tag] == appDelegate.ProductData[i]["Pname"]! {
                
              
               // print("\(ProductFilter[sender.tag]) = \(appDelegate.ProductData[i]["Pname"]!)")
                
                selectI = i
                var j = 0
                
                while j < appDelegate.OrderData.count {
                    if "\(appDelegate.OrderData[j]["Pname"]!)" == ProductFilter[sender.tag] {
                        
                        check = true
                        print("Mee")
                        print("\(i)")
                        selectI = j
                        
                    }else{
                        
                    
                    }
                    
                    
                    j = j + 1
                }
                
                
            }
            i = i + 1
        }
        
        if check == true {
            let c = Int(appDelegate.OrderData[selectI]["Pamount"]!)!
            appDelegate.OrderData[selectI]["Pamount"] = "\(c+1)"
            
            
        }else{
            var test = [[String:String]]()
            test = appDelegate.ProductData
            test[selectI]["Pamount"] = "1"
            appDelegate.OrderData.append(test[selectI])
            addCartIcon(i: appDelegate.OrderData.count)
        }
        
        tableView.reloadData()
        
    }
}
