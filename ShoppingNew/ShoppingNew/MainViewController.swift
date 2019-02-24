//
//  MainViewController.swift
//  ShoppingMedical
//
//  Created by Nontawat on 18/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import ImageSlideshow
import Toast_Swift



class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIScrollViewDelegate , UICollectionViewDelegateFlowLayout {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var ImageShow: ImageSlideshow!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var SearchBar: UISearchBar!

    
    let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var label:UILabel!
    var rightButton:UIButton!
    var bgCart:UIImage!
    var count = 1
    static let shareMain = MainViewController()
    static var PName:[String] = []
    
    var CatFilter = [String]()
    var dataCat = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor(red: 76/255, green: 76/255, blue: 80/255, alpha: 1.0)
        
        print("addCarticon")
        collectionView.dataSource = self
        collectionView.delegate = self
        SearchBar.delegate = self
        
     
         view.backgroundColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1)

        collectionView.backgroundColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1)
        SearchBar.barTintColor = UIColor.white
        
        SearchBar.layer.borderWidth = 2.0
        
        SearchBar.layer.borderColor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showIcon(notification:)), name: Notification.Name("addCarticon"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCollection(notification:)), name: Notification.Name("reloadCollection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadUser(notification:)), name: Notification.Name("reloadUser"), object: nil)
        
        collectionView.reloadData()
        
        getImageSlide()
        
        
      
        
    }
    
    func getImageSlide() {
        
        ImageShow.layer.cornerRadius = 5.0
        ImageShow.slideshowInterval = 2.5
        ImageShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        ImageShow.contentScaleMode = .scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        ImageShow.pageIndicator = pageControl
        
        ImageShow.activityIndicator = DefaultActivityIndicator()
        
        ImageShow.setImageInputs(localSource)
    }
    
    
    @objc func showIcon(notification: Notification){
        addCartIcon(i: appDelegate.OrderData.count)
       
    }
    
    func loadCatFilter() {
        
        dataCat.removeAll()
        CatFilter.removeAll()
        
        var i = 0
        while i < appDelegate.CategoryData.count {
            
           // print("หมวด \(appDelegate.CategoryData[i]["Cid"]!)")
            
            CatFilter.append(appDelegate.CategoryData[i]["Cname"]!)
            
            i = i + 1
        }
        
        
        print("LoadCatFilter")
        
        dataCat = CatFilter
        
        collectionView.reloadData()
        
    }
    
    @objc func reloadCollection(notification: Notification){
        
        loadCatFilter()
        
    }
    
    @objc func reloadUser(notification: Notification){
       
        getDetailUser(username: UserDefaults.standard.string(forKey: "EmailUser")!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        
      //  getDetailUser(username: UserDefaults.standard.string(forKey: "EmailUser")!)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        print("\(UserDefaults.standard.string(forKey: "EmailUser")!)")
        
         getDetailUser(username: UserDefaults.standard.string(forKey: "EmailUser")!)
        
        print("Main")
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
        tabBarController?.navigationItem.title? = "หมวดหมู่"
        
        print("\(appDelegate.CategoryData.count)")
        loadCatFilter()
        
      // NotificationCenter.default.post(name: Notification.Name("addCarticon"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func getDetailUser(username:String) {
        //creating a NSURL
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/customer?cus_username=\(username)")
        
        print("ISSs \(username)")
        

        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in

            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {

                        self.appDelegate.UserDetail["username"] = (jsonObj!.value(forKey: "cus_username")!) as! String
                        self.appDelegate.UserDetail["password"] = (jsonObj!.value(forKey: "cus_password")!) as! String
                        self.appDelegate.UserDetail["fname"] = (jsonObj!.value(forKey: "cus_fname")!) as! String
                        self.appDelegate.UserDetail["lname"] = (jsonObj!.value(forKey: "cus_lname")!) as! String
                        self.appDelegate.UserDetail["phone"] = (jsonObj!.value(forKey: "cus_phone")!) as! String
                        self.appDelegate.UserDetail["email"] = (jsonObj!.value(forKey: "cus_email")!) as! String
                        self.appDelegate.UserDetail["pic"] = (jsonObj!.value(forKey: "cus_picture")!) as! String
                        self.appDelegate.UserDetail["typeLogin"] = "\((jsonObj!.value(forKey: "cus_type_login")!) as! Int)"


                OperationQueue.main.addOperation({

                    print("\(self.appDelegate.UserDetail)")
                    
                    print("SSSS \(self.appDelegate.UserDetail.count)")
                    //NotificationCenter.default.post(name: Notification.Name("ShowUser"), object: nil)

                })
            }
        }).resume()
        
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
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightButton)
    }
    
    
    @objc  func pluscount() {
      
        if appDelegate.OrderData.count == 0 {
            self.view.makeToast("ไม่มีสินค้าในตะกร้า", duration: 0.5, position: .bottom)
            
        }else {
            tabBarController?.selectedIndex = 1
        }
        
    }
    
    
    
    //collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return CatFilter.count
    }
    
    //collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
        
        
        
       // print("\(dataCat.count)")
        var i = 0
        var Catid = 0
        while i < dataCat.count {
            if CatFilter[indexPath.item] == appDelegate.CategoryData[i]["Cname"]! {
                //print("cat \(appDelegate.CategoryData[i]["Cname"]!)")
                Catid = Int(appDelegate.CategoryData[i]["Cid"]!)!
               // print("ID \(Catid)")
            }
            i = i + 1
        }

        cell.LabelCell.font = UIFont(name: "Prompt-Regular", size: 13)
        cell.LabelCell.text = "\(appDelegate.CategoryData[Catid-1]["Cname"]!)"


        let url = URL(string: "https://ubonmed.pandascoding.com/images/\(appDelegate.CategoryData[Catid-1]["Cpic"]!)")
        cell.ImageCell.kf.setImage(with: url)

        cell.ImageCell.layer.masksToBounds = true
        cell.ImageCell.layer.cornerRadius = 5.0


        cell.ImageCell.backgroundColor = UIColor.white
    
        
        return cell
    }
    
    //update search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        CatFilter = searchText.isEmpty ? dataCat : dataCat.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

     print(CatFilter)
        
    collectionView.reloadData()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = 155
        let cellWidth = (collectionView.bounds.size.width - 15) / 3 // 2 count of colomn to show
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        print("\(indexPath.item)")

       self.performSegue(withIdentifier: "goProduct", sender: nil)

        var i = 0
        while i < dataCat.count {
            if CatFilter[indexPath.item] == dataCat[i] {
                appDelegate.SelectCat = Int(appDelegate.CategoryData[i]["Cid"]!)!
                print("Name \(CatFilter[indexPath.item])")
            }
            i = i + 1
        }

        SearchBar.text = ""
        CatFilter = dataCat
        collectionView.reloadData()

    }
    
  
    
    
}


