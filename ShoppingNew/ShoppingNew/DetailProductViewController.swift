//
//  DetailProductViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 25/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit
import iOSDropDown

class DetailProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
    @IBOutlet weak var ChooseBT: UIButton!
    
    @IBOutlet weak var TableViewChoose: UITableView!
    
    @IBOutlet weak var tblDropdown: NSLayoutConstraint!
    
    var isTableviewVisible = false
    
    
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    
    @IBOutlet weak var AddProduct: UIButton!
    @IBOutlet weak var detailProduct: UITextView!
    @IBOutlet weak var addBT: UIButton!
    
    @IBOutlet weak var removeBT: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var imageProduct: UIImageView!
    
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var label:UILabel!
    var rightButton:UIButton!
    var bgCart:UIImage!
    var ChooseProduct = [[String:String]]()
    var selectChoose = 0
    var selectChooseCheck = false
    var selectedIndexPath:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.title = "รายละเอียดสินค้า"
         view.backgroundColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
       
        AddProduct.layer.cornerRadius = 5.0
        
        let item = appDelegate.ProductData[appDelegate.SelectProduct]
        
        let url = URL(string: "https://ubonmed.pandascoding.com/images/\(item["Ppic"]!)")
        imageProduct.kf.setImage(with: url)
        
        imageProduct.layer.masksToBounds = true
        imageProduct.layer.cornerRadius = 5.0

        detailProduct.layer.cornerRadius = 5.0
        detailProduct.text = item["Pdescription"]!
        nameProduct.text = item["Pname"]!
        
        let price = Int(item["Pprice"]!)
        priceProduct.text = "ราคา \(price!.delimiter) บาท"
        amountLabel.text = "1"
        
        
        
        //TableViewChoose
        ChooseBT.layer.cornerRadius = 5.0
        TableViewChoose.delegate = self
        TableViewChoose.dataSource = self
        TableViewChoose.separatorColor = UIColor.clear
        tblDropdown.constant = 0
      
        
        print("Chooses \(item["Pchoose"]!)")
        
        if Int(item["Pchoose"]!) == 1 {
            getChooses(i: Int(item["Pid"]!)!)
            print("True")
        } 
        
        
        addCartIcon(i: appDelegate.OrderData.count)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChooseProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewChoose.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DropCell
        
        
        cell.ImageCell.layer.masksToBounds = true
        if selectedIndexPath == indexPath {
   
             cell.ImageCell.image = UIImage(named: "icon_check")
             cell.ImageCell.layer.borderWidth = 0.0
        }else{
            
            cell.ImageCell.image = UIImage(named: "icon_chasd")
            cell.ImageCell.layer.borderColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 1.0).cgColor
            cell.ImageCell.layer.borderWidth = 1.0
        }
        
        
        
        cell.ImageCell.layer.cornerRadius = 3.0
        
        cell.NameCell.text = "\(ChooseProduct[indexPath.item]["choose_name"]!)"
        
        let price = Int(ChooseProduct[indexPath.item]["choose_price"]!)
        
        cell.PriceCell.text = "ราคา \(price!.delimiter) บาท"
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       
        selectedIndexPath = indexPath
        
        selectChoose = indexPath.item
        selectChooseCheck = true
        
        print("select \(selectChoose)")
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCell = tableView.cellForRow(at: indexPath) as! DropCell
        
        ChooseBT.setTitle("      \(currentCell.NameCell.text!)", for: .normal)
        
        priceProduct.text = "\(currentCell.PriceCell.text!)"
        
        nameProduct.text = "\(appDelegate.ProductData[appDelegate.SelectProduct]["Pname"]!) \(currentCell.NameCell.text!)"
        UIView.animate(withDuration: 0.5) {
            self.tblDropdown.constant = 0.0
            self.isTableviewVisible = false
            self.view.layoutIfNeeded()
        }
        
      
        
        
    }

  
    
    @IBAction func ChooseAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            
            if self.isTableviewVisible == false {
                
                self.isTableviewVisible = true
                self.tblDropdown.constant = self.TableViewChoose.rowHeight * CGFloat(self.ChooseProduct.count)
            
                
            }else{
                
                self.tblDropdown.constant = 0.0
                self.isTableviewVisible = false
                
            }
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    
    
    
    @objc  func pluscount() {
        
        if appDelegate.OrderData.count == 0 {
            self.view.makeToast("ไม่มีสินค้าในตะกร้า", duration: 0.5, position: .bottom)
            
        }else {
            self.navigationController?.popToRootViewController(animated: true)
            appDelegate.AccessOpen = true
        }
      
        
        
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
    

    @IBAction func removeAmount(_ sender: Any) {
        let am = Int(amountLabel.text!)
        if am != 0 {
            amountLabel.text = "\( am! - 1 )"
        }
    }
    @IBAction func AddAmount(_ sender: Any) {
        let i =  Int(amountLabel.text!)
         amountLabel.text = "\(i! + 1)"

    }
    

    
    func getChooses(i:Int) {
        //creating a NSURL
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/product/one?product_id=\(i)")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            var dataP = [[String:String]]()
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //  let status = (jsonObj!.value(forKey: "status")!) as! Int
                
                
                if let dataArray = jsonObj!.value(forKey: "prod_choose") as? NSArray {
                    
                    
                    for dataList in dataArray{
                        
                        if let heroeDict = dataList as? NSDictionary {
                            
                         
                            let chooseName = "\(heroeDict.value(forKey: "choose_name")!)"
                            
                            print("IS \(chooseName)")
                            self.ChooseProduct.append(["choose_id": "\(heroeDict.value(forKey: "choose_id")!)",
                                                  "choose_name": "\(heroeDict.value(forKey: "choose_name")!)",
                                                  "choose_of_product": "\(heroeDict.value(forKey: "choose_of_product")!)",
                                                  "choose_price": "\(heroeDict.value(forKey: "choose_price")!)",
                                                 "choose_active": "\(heroeDict.value(forKey: "choose_active")!)"
                                
                                                  ])
                           
                           
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
        
                self.TableViewChoose.reloadData()
                    
                })
            }
        }).resume()
    }
    
    
    @IBAction func addOrder(_ sender: Any) {
        
        let amount = Int(amountLabel.text!)
        
        if amount != 0 {
            
        AlertSuccess()
            

            var Pprice = 0
            var Pname = ""
            var Pamonut = 0
            var PChoose = ""
            
            if selectChooseCheck == true{
                
               Pname = nameProduct.text!
               Pprice = Int(ChooseProduct[selectChoose]["choose_price"]!)!
               Pamonut = amount!
               PChoose = "\(ChooseProduct[selectChoose]["choose_id"]!)"
            }else {
                
                Pname = nameProduct.text!
                Pprice = Int(appDelegate.ProductData[appDelegate.SelectProduct]["Pprice"]!)!
                Pamonut = amount!
                PChoose = "0"

            }
            
            
            
        
        if appDelegate.OrderData.count == 0 {
            var test = [[String:String]]()
            test = appDelegate.ProductData
            test[appDelegate.SelectProduct]["Pamount"] = "\(Pamonut)"
            test[appDelegate.SelectProduct]["Pchoose"] = "\(PChoose)"
            test[appDelegate.SelectProduct]["Pprice"] = "\(Pprice)"
            test[appDelegate.SelectProduct]["Pname"] = "\(Pname)"
            appDelegate.OrderData.append(test[appDelegate.SelectProduct])
            label.text = "\(appDelegate.OrderData.count)"

            
        }else {
            
            var i = 0
            var check = false
            var IndexOld = 0
            
            while i < appDelegate.OrderData.count{
                
                if Pname == appDelegate.OrderData[i]["Pname"]! {
                    
                    print("Equal")
                    check = true
                    IndexOld = i
                }
                i = i + 1
            }
            
            
            if check == true {
                let oldsum = Int(appDelegate.OrderData[IndexOld]["Pamount"]!)
                let newsum = Int(amountLabel.text!)
                appDelegate.OrderData[IndexOld]["Pamount"] = "\(oldsum! + newsum!)"
               // print("\(appDelegate.OrderData[IndexOld]["Pamount"])")

            }else{
                var test = [[String:String]]()
                test = appDelegate.ProductData
                test[appDelegate.SelectProduct]["Pamount"] = "\(Pamonut)"
                test[appDelegate.SelectProduct]["Pchoose"] = "\(PChoose)"
                test[appDelegate.SelectProduct]["Pprice"] = "\(Pprice)"
                test[appDelegate.SelectProduct]["Pname"] = "\(Pname)"
                appDelegate.OrderData.append(test[appDelegate.SelectProduct])
                label.text = "\(appDelegate.OrderData.count)"
            }
   
            
        }
            
          //  performSegue(withIdentifier: "goCart", sender: nil)
            
        }
        
        
        
    }
    
    
    func AlertSuccess() {
        
        
        let attributedString = NSAttributedString(string: "เพิ่มลงในตะกร้าสินค้าเรียบร้อยแล้ว", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.black,
            ])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        // alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alert,animated: true,completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            
            
            NotificationCenter.default.post(name: Notification.Name("addCarticon"), object: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
//            self.performSegue(withIdentifier: "goHome", sender: self)
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        
    }
}
