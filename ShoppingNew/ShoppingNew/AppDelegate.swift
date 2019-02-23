//
//  AppDelegate.swift
//  ShoppingNew
//
//  Created by Nontawat on 24/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shareApp = AppDelegate()
    var window: UIWindow?
    
    var BankData = [[String:String]]()
    var OrderData = [[String:String]]()
    var ProductData = [[String:String]]()
    
    var CategoryData = [[String:String]]()
    var UserDetail = [String: String]()
    var AddressUse = [String: String]()
    
    
    var filterCategory = [String]()
    
    var SelectCat = 0
    var SelectProduct = 0
    var HistorySelect = ""
    var selectEditAddress = 0
    var AddressData = [[String:String]]()
    
//    var dict = [
//                [
//                ["name1": "John", "surname": "Doe"],
//                ["name2": "John", "surname": "Doe"]
//                ],
//                ]
    
    var AccessOpen = false
    var HistoryOpen = false



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "SukhumvitSet-Medium", size: 11),NSAttributedString.Key.foregroundColor: UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)], for: .normal)
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SukhumvitSet-Bold", size: 20), NSAttributedString.Key.foregroundColor: UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)]
        
        getBank()
        getCategory()
  
        
        print("SADDD \(ProductData.count)")
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation:annotation)
    }
    
    
    func getBank(){
        //creating a NSURL
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/bank")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //  let status = (jsonObj!.value(forKey: "status")!) as! Int
                
                
                if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                    
        
                    for dataList in dataArray{

                        if let heroeDict = dataList as? NSDictionary {
                        
                            
                           // print("name \(heroeDict.value(forKey: "bank_name")!)")
                            let transfer_id = "\(heroeDict.value(forKey: "transfer_id")!)"
                            let transfer_bank = "\(heroeDict.value(forKey: "transfer_bank")!)"
                            let transfer_account = "\(heroeDict.value(forKey: "transfer_account")!)"
                            let transfer_name = "\(heroeDict.value(forKey: "transfer_name")!)"
                            let bank_name = "\(heroeDict.value(forKey: "bank_name")!)"
                            let bank_picture = "\(heroeDict.value(forKey: "bank_picture")!)"
                            
                            self.BankData.append(["transfer_id": transfer_id, "transfer_bank": transfer_bank, "transfer_account": transfer_account, "transfer_name": transfer_name, "bank_name": bank_name, "bank_picture": bank_picture])
                       
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                  
                    //Finished
              
                    
                  //  NotificationCenter.default.post(name: Notification.Name("addCarticon"), object: nil)
                    
                })
            }
        }).resume()
    }
    
    func getCategory(){
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/category")
     
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            var dataP = [[String:String]]()
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                if let dataArray = jsonObj!.value(forKey: "data") as? NSArray {
                    
                    for dataList in dataArray{
                        
                        if let heroeDict = dataList as? NSDictionary {
                            
                            
                            let Cid = "\(heroeDict.value(forKey: "cat_id")!)"
                            let Cname = "\(heroeDict.value(forKey: "cat_name")!)"
                            let Cpic = "\(heroeDict.value(forKey: "cat_picture")!)"
                            let Cship_fee = "\(heroeDict.value(forKey: "cat_ship_fee")!)"
                            let Cactive = "\(heroeDict.value(forKey: "cat_active")!)"
                        
                            
                           
                            self.CategoryData.append(["Cid": Cid,
                                                      "Cname": Cname,
                                                      "Cpic": Cpic,
                                                      "Cshipfee": Cship_fee,
                                                      "Cactive": Cactive])
                            
                            self.filterCategory.append("\(Cname)")
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    
                    print("IOOOOO \(self.CategoryData.count)")
                    print("asdasd \(self.filterCategory.count)")
                   
                    
                    
                    NotificationCenter.default.post(name: Notification.Name("reloadCollection"), object: nil)
                    
                })
            }
        }).resume()
        
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

