//
//  AlertLoginViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 2/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class AlertLoginViewController: UIViewController {

    @IBOutlet weak var closeBT: UIButton!
    @IBOutlet weak var loginBT: UIButton!
    @IBOutlet weak var viewpop: UIView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    var checkstatus = false
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewpop.layer.cornerRadius = 5.0
        
        loginBT.layer.cornerRadius = 5.0
        
        closeBT.layer.cornerRadius = 5.0
        closeBT.layer.borderWidth = 1.0
        closeBT.layer.borderColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
       
    }
    
    
    func CheckUser(username:String, password:String){
        //creating a NSURL
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/customer?cus_username=\(username)")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let check = (jsonObj!.value(forKey: "status")!) as? Bool
                print("user LLL \(check!)")
                
                
                if check! == true{
                      let user = (jsonObj!.value(forKey: "cus_username")!) as? String
                      let pass = (jsonObj!.value(forKey: "cus_password")!) as? String
                    print(user!)
                    
                    if username == user! && password == pass! {
                          print("SUccesss")
                        self.checkstatus = true
                    }else{
                        print("fail")
                    }
                    
                }else{
                    print("fail")
                }
                OperationQueue.main.addOperation({
                    
                    
                    if self.checkstatus == true {
                        self.AlertSuccess()
                    }
                
               
                    
                    
                })
            }
        }).resume()
        
        
    }
    
    
    func AlertSuccess() {
        
        
        let attributedString = NSAttributedString(string: "Login Success!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.black,
            ])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        // alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alert,animated: true,completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            alert.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
            UserDefaults.standard.set(self.usernameInput.text!, forKey: "EmailUser")
           self.performSegue(withIdentifier: "goLogin", sender: nil)
        }
        
    }
    
    

    @IBAction func LoginBT(_ sender: Any) {
        
        CheckUser(username: usernameInput.text!, password: passwordInput.text!)
    }
    
    @IBAction func CLoseBT(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
       // performSegue(withIdentifier: "goLogin", sender: nil)
    }
    
}
