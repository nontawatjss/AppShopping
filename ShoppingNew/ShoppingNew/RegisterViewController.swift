//
//  RegisterViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 19/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var ViewFrom: UIView!
    
    @IBOutlet weak var ScrollV: UIScrollView!
    @IBOutlet weak var BTRegister: UIButton!
    
    @IBOutlet weak var FName: UITextField!
    @IBOutlet weak var LName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Tell: UITextField!
    @IBOutlet weak var Pass1: UITextField!
    @IBOutlet weak var Pass2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       CustomView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
      
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    func CustomView() {
        
        navigationItem.title = "สมัครสมาชิก"
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        
          self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        BTRegister.layer.cornerRadius = 5.0
        
        ViewFrom.layer.cornerRadius = 5.0
//            FName.layer.borderWidth = 10.0
//            FName.layer.borderColor = UIColor.red.cgColor
        FName.layer.cornerRadius = 5.0
        FName.layer.borderWidth = 1
        FName.layer.borderColor = LName.backgroundColor?.cgColor
        LName.layer.cornerRadius = 5.0
        LName.layer.borderWidth = 1
        LName.layer.borderColor = LName.backgroundColor?.cgColor
        Email.layer.cornerRadius = 5.0
        Email.layer.borderWidth = 1
        Email.layer.borderColor = LName.backgroundColor?.cgColor
        Tell.layer.cornerRadius = 5.0
        Tell.layer.borderWidth = 1
        Tell.layer.borderColor = LName.backgroundColor?.cgColor
        Pass1.layer.cornerRadius = 5.0
        Pass1.layer.borderWidth = 1
        Pass1.layer.borderColor = LName.backgroundColor?.cgColor
        Pass2.layer.cornerRadius = 5.0
        Pass2.layer.borderWidth = 1
        Pass2.layer.borderColor = LName.backgroundColor?.cgColor
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print("H Key \(keyboardHeight)")
        }
    }
    
    

    @IBAction func ClickRegister(_ sender: Any) {
        
        if (FName.text?.isEmpty)! || (LName.text?.isEmpty)! || (Email.text?.isEmpty)! || (Tell.text?.isEmpty)! || (Pass1.text?.isEmpty)! || (Pass2.text?.isEmpty)!{
            print("มีช่องว่าง")
        }else {
            print("ไม่ว่างหมด")
            if (Pass1.text! == Pass2.text!){
                
                getUser(username: "\(Email.text!)")
                
            }else{
                print("รหัสไม่ตรงกัน")
            }
        }
    }
    
    
    
    func getUser(username:String){
        //creating a NSURL
        var check = false
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/customer?cus_username=\(username)")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let teststatus = (jsonObj!.value(forKey: "status")!) as! Bool
                print("user LLL \(teststatus)")
                check = (teststatus)
                
                OperationQueue.main.addOperation({
                    
                    
                    if check != true {
                        print("เพิ่มสมาชิกสำเร็จ!!")
                        self.addUser(user: self.Email.text!, pass: self.Pass1.text!, fname: self.FName.text!, lname: self.LName.text!, phone: self.Tell.text!, email: self.Email.text!, pic: "https://ubonmed.pandascoding.com/images/avatar5.png")
                        self.AlertSuccess()

                    }else {
                        self.AlertFail()
                    }
                    
                    
                    
                })
            }
        }).resume()
        
        
    }
    
    
    func AlertSuccess() {
        
        
        let attributedString = NSAttributedString(string: "Success new account!!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.black,
            ])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
       // alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alert,animated: true,completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // your code here
            alert.dismiss(animated: true, completion: nil)
            self.setEmptyText()
        }
    
    }
    
    func AlertFail() {
        
        
        let attributedString = NSAttributedString(string: "Username มีอยู่ในระบบเเล้ว!!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.red,
            ])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        // alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alert,animated: true,completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // your code here
            alert.dismiss(animated: true, completion: nil)
            self.setEmptyText()
        }
        
    }
    
    
    func setEmptyText(){
        FName.text = nil
        LName.text = nil
        Email.text = nil
        Tell.text = nil
        Pass1.text = nil
        Pass2.text = nil
        
    }
    
    //Post API
    func addUser(user:String,pass:String,fname:String,lname:String,phone:String,email:String,pic:String){
        
        print("Okk")
        
        let data: [String: Any] = [
            "cus_username": user,
            "cus_password": pass,
            "cus_fname": fname,
            "cus_lname": lname,
            "cus_phone" : phone,
            "cus_email": email,
            "cus_picture": "https://ubonmed.pandascoding.com/images/noimg.png",
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
                print("Success! New Account")
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    
   
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            ScrollV.contentInset = UIEdgeInsets.zero
        } else {
            ScrollV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        ScrollV.scrollIndicatorInsets = ScrollV.contentInset
        
      //  let selectedRange = Pass2.selectedRange
      //  Pass2.scrollRangeToVisible(selectedRange)
    }
    

    
    
  
}
