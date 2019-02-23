//
//  EditAddressViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 18/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class EditAddressViewController: UIViewController {

    @IBOutlet weak var ViewForm: UIView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var Province: UITextField!
    
    @IBOutlet weak var Fname: UITextField!
    
    @IBOutlet weak var Lname: UITextField!
    
    @IBOutlet weak var Adress1: UITextField!
    
    @IBOutlet weak var tambon: UITextField!
    
    @IBOutlet weak var amphoe: UITextField!
    
    
    @IBOutlet weak var ZipCode: UITextField!
    
    
    @IBOutlet weak var EditBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "แก้ไขข้อมูลที่อยู่"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton

        
        ViewForm.layer.cornerRadius = 5.0
        EditBT.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        loadAddress()
    }
    
    
    func loadAddress() {
        
        var i = 0
        
        while i < appDelegate.AddressData.count {
            
            if i == appDelegate.selectEditAddress {
                
                Fname.text = "\(appDelegate.UserDetail["fname"]!)"
                Lname.text = "\(appDelegate.UserDetail["lname"]!)"
                Adress1.text = "\(appDelegate.AddressData[i]["Aline1"]!)"
                tambon.text = "\(appDelegate.AddressData[i]["Atambon"]!)"
                amphoe.text = "\(appDelegate.AddressData[i]["Aamphoe"]!)"
                Province.text = "\(appDelegate.AddressData[i]["Aprovince"]!)"
                ZipCode.text = "\(appDelegate.AddressData[i]["Acode"]!)"
                
                
            }

            
            i = i + 1
        }
        
        
    }
    

    @IBAction func EditAction(_ sender: Any) {
    }
    

}
