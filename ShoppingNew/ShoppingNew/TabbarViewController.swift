//
//  TabbarViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 18/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import  Toast_Swift

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    @IBOutlet weak var NaviBar: UINavigationItem!
     var appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        view.backgroundColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1)
       
        tabBar.items?[0].imageInsets = UIEdgeInsets(top: -6, left: 0, bottom: -3, right: 0)
        tabBar.items?[1].imageInsets = UIEdgeInsets(top: -6, left: 0, bottom: -3, right: 0)
        tabBar.items?[2].imageInsets = UIEdgeInsets(top: -6, left: 0, bottom: -3, right: 0)
   
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 73.0/255.0, green: 80.0/255.0, blue: 87.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.white
         navigationItem.title = ""
        
        
        
    }
    
    
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is MainViewController {
            print("First tab")
        } else if viewController is CartViewController {
            print("Second tab \(appDelegate.OrderData.count)")
            if appDelegate.OrderData.count == 0 {
                self.view.makeToast("ไม่มีสินค้าในตะกร้า", duration: 0.5, position: .bottom)
    
                self.selectedIndex = 0
            }
        
        } else if viewController is AccountViewController {
            print("Three tab")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("change")
        
        if(appDelegate.AccessOpen == true){
            navigationItem.title = "ตะกร้าสินค้า"
            self.selectedIndex = 1
            appDelegate.AccessOpen = false
        }else if(appDelegate.HistoryOpen == true){
            navigationItem.title = "บัญชีผู้ใช้"
            self.selectedIndex = 2
        }else {
            navigationItem.title = "หน้าหลัก"
            self.selectedIndex = 0
            appDelegate.AccessOpen = false
            appDelegate.HistoryOpen = false
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        }

    }
  
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
