//
//  AlertViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 28/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var AlertV: UIView!
    @IBOutlet weak var ImageIcon: UIImageView!
    @IBOutlet weak var FollowOrder: UIButton!
    @IBOutlet weak var BacktoHome: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        BacktoHome.layer.cornerRadius = 5.0
        FollowOrder.layer.cornerRadius = 5.0
        BacktoHome.layer.borderWidth = 1.0
        BacktoHome.layer.borderColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        AlertV.layer.cornerRadius = 5.0
    }
    
    @IBAction func CLoseAlert(_ sender: Any) {
        self.appDelegate.OrderData.removeAll()
        dismiss(animated: true, completion: nil)
     
        NotificationCenter.default.post(name: Notification.Name("SwapView"), object: nil)
        appDelegate.HistoryOpen = false
        appDelegate.AccessOpen = false
    }


    @IBAction func ExitHome(_ sender: Any) {
        self.appDelegate.OrderData.removeAll()
         dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: Notification.Name("SwapView"), object: nil)
      
        appDelegate.HistoryOpen = true
        appDelegate.AccessOpen = false
        
    }
    
}
