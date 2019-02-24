//
//  AccountViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 19/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var numbers = ["ข้อมูลส่วนตัว","ข้อมูลที่อยู่","ประวัติการสั่งซื้อ","เกี่ยวกับเรา","ออกจากระบบ"]
    var iconMenu = ["icon_infomation","icon_address","icon_history_order","icon_home","icon_logout"]
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        viewAll.layer.cornerRadius = 5.0
        viewImage.layer.cornerRadius = 5.0
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.showuser(notification:)), name: Notification.Name("ShowUser"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if appDelegate.HistoryOpen == true {
            performSegue(withIdentifier: "goHistory", sender: nil)
            appDelegate.HistoryOpen = false
        }
        
        tabBarController?.navigationItem.title? = "บัญชีผู้ใช้"
        //print("\(MainViewController.count)")
        
      self.navigationController!.navigationBar.tintColor = UIColor(red: 76/255, green: 76/255, blue: 80/255, alpha: 1.0)
     
      //  NotificationCenter.default.post(name: Notification.Name("addCarticon"), object: nil)
        
        
        print("IN 2")
        let url = URL(string: "\(appDelegate.UserDetail["pic"]!)")
        image.kf.setImage(with: url)
        
        nameUser.text = "\(appDelegate.UserDetail["fname"]!) \(appDelegate.UserDetail["lname"]!)"
        emailUser.text = "\(appDelegate.UserDetail["email"]!)"
        
        
        
    }

    
    @objc func showuser(notification: Notification){
        let url = URL(string: "\(appDelegate.UserDetail["pic"]!)")
        image.kf.setImage(with: url)
        
        nameUser.text = "\(appDelegate.UserDetail["fname"]!) \(appDelegate.UserDetail["lname"]!)"
        emailUser.text = "\(appDelegate.UserDetail["email"]!)"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
      
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AccountCell
        
       cell.NameLabel.text = "\(numbers[indexPath.item])"
        func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
            
            let hasAlpha = true
            let scale: CGFloat = 0.0 // Use scale factor of main screen
            
            UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
            image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            return scaledImage!
        }
        
        let w = Double((UIImage(named: "\(iconMenu[indexPath.item])")?.size.width)!)
        let h = Double((UIImage(named: "\(iconMenu[indexPath.item])")?.size.height)!)
        let size = CGSize(width: 27, height: h/3.0)
        
//        cell.imageView?.image = imageResize(image: UIImage(named: "\(iconMenu[indexPath.item])")!, sizeChange: size)
        
        //cell.imageView?.image = UIImage(named: "\(iconMenu[indexPath.item])")
        
        cell.ImgCell.image = UIImage(named: "\(iconMenu[indexPath.item])")
        
      //  print("\(UIImage(named: "\(iconMenu[indexPath.item])")?.size.height)")
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            performSegue(withIdentifier: "goDetail", sender: nil)
            break
        case 1:
            print("1")
            performSegue(withIdentifier: "goAddress", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "goHistory", sender: nil)
            break
        case 3:
            performSegue(withIdentifier: "goContact", sender: nil)
            print("\(FBSDKAccessToken.current()?.userID!)")
            break
        case 4:
          print("4")
         
          FBSDKLoginManager().logOut()
          FBSDKLoginManager().logOut()

          UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
          UserDefaults.standard.set("", forKey: "EmailUser")
         // performSegue(withIdentifier: "goLogin", sender: nil)
          dismiss(animated: true, completion: nil)
          
            break
        default: break
            
        }
    }

 
    
}
