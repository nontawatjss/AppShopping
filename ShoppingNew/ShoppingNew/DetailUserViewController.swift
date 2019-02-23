//
//  DetailUserViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 20/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import Alamofire

class DetailUserViewController: UIViewController{

   
    @IBOutlet weak var ViewForm: UIView!
    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    
    @IBOutlet weak var TelInput: UITextField!
    
    @IBOutlet weak var Pass1: UITextField!
    @IBOutlet weak var Pass2: UITextField!
    @IBOutlet weak var BTConfirm: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let backButton = UIBarButtonItem()
        backButton.title = ""

        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        navigationItem.title = "ข้อมูลผู้ใช้งาน"
     
        ViewForm.layer.cornerRadius = 5.0
        BTConfirm.layer.cornerRadius = 5.0
        
        
        showUserDetail()
        
       
    }
    
    func showUserDetail() {
        
        Fname.text = appDelegate.UserDetail["fname"]
        Lname.text = appDelegate.UserDetail["lname"]
        EmailInput.text = appDelegate.UserDetail["email"]
        TelInput.text = appDelegate.UserDetail["phone"]
        Pass1.text = appDelegate.UserDetail["password"]
        Pass2.text = appDelegate.UserDetail["password"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ข้อมูลส่วนตัว")
    }
    
    @IBAction func ActionConfirm(_ sender: Any) {
        if (Fname.text != "" || Lname.text != "" || EmailInput.text != "" || Pass1.text != "" || Pass2.text != "" || TelInput.text != "") {
            
            if Pass1.text == Pass2.text {
                
                EditUser(user: appDelegate.UserDetail["username"]!, pass: Pass1.text!, fname: Fname.text!, lname: Lname.text!, phone: TelInput.text!, email: EmailInput.text!)
                AlertSuccess()
            }else {
                print("Passwordใหม่ ไม่ตรงกัน")
                AlertFail()
            }
            
        }else {
            print("กรอกให้ครบ")
            AlertFail()
        }
        
    }
    
    
    func AlertSuccess() {
        
        
        let attributedString = NSAttributedString(string: "อัพเดตข้อมูลสำเร็จ!!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.black,
            ])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        // alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alert,animated: true,completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func AlertFail() {
        
        
        let attributedString = NSAttributedString(string: "อัพเดตข้อมูลไม่สำเร็จ!!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.red,
            ])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        // alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alert,animated: true,completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func setEmptyText(){
        Fname.text = nil
        Lname.text = nil
        EmailInput.text = nil
        TelInput.text = nil
        Pass1.text = nil
        Pass2.text = nil
        
    }
    
    
    //EditUser
    func EditUser(user:String,pass:String,fname:String,lname:String,phone:String,email:String){
        
        let data: [String: Any] = [
            "cus_username": user,
            "cus_password": pass,
            "cus_fname": fname,
            "cus_lname": lname,
            "cus_phone" : phone,
            "cus_email": email,
        ]
        
        let urlString = "https://ubonmed.pandascoding.com/api/customer/edit"
        
        Alamofire.request(urlString, method: .post, parameters: data ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                NotificationCenter.default.post(name: Notification.Name("reloadUser"), object: nil)
                
                print("Success! New Account")
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    
    
    
    
    
}
