//
//  LoginViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 19/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

import FacebookLogin
import FBSDKLoginKit
import Alamofire

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginViewController: UIViewController{

    @IBOutlet weak var FBLogin: UIButton!
    
    @IBOutlet weak var EmailLogin: UIButton!
    
    @IBOutlet weak var MailIcon: UIImageView!
    
    var text:String = "sdsd"
    var dict : [String : AnyObject]!
    let loginManager = LoginManager()
    var UserData = [String: String]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        CustomView()
       
        //print("ISSSS \(FBSDKAccessToken.current()?.userID!)")
        
        if (FBSDKAccessToken.current()?.userID != nil) || (UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true) {
            
            print("Logon With ?")
            print("Email \(UserDefaults.standard.string(forKey: "EmailUser")!)")
           
            self.performSegue(withIdentifier: "goLogin", sender: self)
            
        }else{
            print("notLogon")
        }
        
        appDelegate.OrderData.removeAll()
        
        
        
    }
    
    
    func CustomView() {
        
        navigationItem.title = "เข้าสู่ระบบ"
        FBLogin.layer.cornerRadius = 5.0
        //        FBLogin.layer.borderWidth = 2.0
        //        FBLogin.layer.borderColor = UIColor.red.cgColor
        
        EmailLogin.layer.cornerRadius = 5.0
        EmailLogin.layer.borderWidth = 1.0
        EmailLogin.layer.borderColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        
        MailIcon.image = MailIcon.image?.withRenderingMode(.alwaysTemplate)
        MailIcon.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)

        
        
    }
    
    @IBAction func LoginWithFacebook(_ sender: Any){
        
        print("Login")
       
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self){ loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
        
        

      
    }
    
    
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                   
                    print(result!)
                    
                    let field = result! as? [String:Any]
                
                    self.UserData["id"] = "\((field!["id"] as? String)!)"
                    self.UserData["email"] = "\((field!["email"] as? String)!)"
                    self.UserData["first_name"] = "\((field!["first_name"] as? String)!)"
                    self.UserData["last_name"] = "\((field!["last_name"] as? String)!)"
                    self.UserData["name"] = "\((field!["name"] as? String)!)"
                    //self.UserData["phone"] = "\((field!["mobile_phone"] as? String)!)"
                    self.UserData["pic"] = "https://graph.facebook.com/\((FBSDKAccessToken.current()?.userID)!)/picture?width=250&height=250"
        
                   
                    self.checkUser()
//                   print(field)
//                    print("SSSS \(self.UserData)")
                    
                    let user = self.UserData["email"]!
                    UserDefaults.standard.set(user, forKey: "EmailUser")
                    
                     self.performSegue(withIdentifier: "goLogin", sender: self)
                    
                }
            })
        }
        
    }
    
    
    func checkUser(){
        print("STATUS \(getUser(username: "\((UserData["email"])!)"))")

    }
    

    func getUser(username:String){
        //creating a NSURL
        var check = false
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/customer?cus_username=\(username)")

        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in

            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {

                let teststatus = (jsonObj!.value(forKey: "status")!) as! Bool
                //print("user LLL \(teststatus)")
                 check = (teststatus)

                OperationQueue.main.addOperation({


                    if check != true {
                        self.addUser(user: self.UserData["email"]!,
                                     pass: self.UserData["id"]!,
                                     fname: self.UserData["first_name"]!,
                                     lname: self.UserData["last_name"]!,
                                     phone: "0",
                                     email: self.UserData["email"]!,
                                     pic: self.UserData["pic"]!)
                    }else {

                    }



                })
            }
        }).resume()


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
            "cus_picture": pic,
            "cus_type_login": 2,
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
   

    @IBAction func LoginEmail(_ sender: Any) {
        //AlertLogin()
//        loginManager.logOut()
        performSegue(withIdentifier: "goAlert", sender: self)
    }
    
    @IBAction func RegisterEmail(_ sender: Any) {
        self.performSegue(withIdentifier: "goRegister", sender: self)
    }
        
    
    }
    
    
    

