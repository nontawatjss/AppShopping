//
//  PayMentViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 27/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit
import Alamofire

class PayMentViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate ,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    @IBOutlet weak var TableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var LabelHide: UILabel!
    @IBOutlet weak var ImgHide: UIImageView!
    
    @IBOutlet weak var BTselectImage: UIButton!
    @IBOutlet weak var BTtakecamera: UIButton!
    @IBOutlet weak var BTfinish: UIButton!
    
    @IBOutlet weak var ViewDown: UIView!
    static var SharrPAY = PayMentViewController()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var choose2 = false,choose1 = false
    
    @IBOutlet weak var ImageShow: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var imagePicker = UIImagePickerController()
    var LastID = 0
    var ImageSlip = UIImage()
    var nameImageSlip = ""
    var InvCode = ""
    var selectBank = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        navigationItem.title = "แจ้งชำระเงิน"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.clear
        tableView.layer.cornerRadius = 5.0
        ViewDown.layer.cornerRadius = 5.0
        ImageShow.layer.cornerRadius = 5.0
        print("asdas")
        
       
        
        //Bt
        BTfinish.layer.cornerRadius = 5.0
        BTfinish.isEnabled = false
        
        BTtakecamera.layer.cornerRadius = 5.0
        BTtakecamera.layer.borderColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        BTtakecamera.layer.borderWidth = 1.0
        
        BTselectImage.layer.cornerRadius = 5.0
        BTselectImage.layer.borderColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        BTselectImage.layer.borderWidth = 1.0
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.swapView(notification:)), name: Notification.Name("SwapView"), object: nil)
        
       
    }
    
    @objc func swapView(notification: Notification){
       print("MAaaa")
        
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       getLastid()
        
        print("TEsss ")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ImageShow
    }

    @IBAction func selectImage(_ sender: Any) {
    
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    
    }
    
    func getLastid(){
        
        
        let url = NSURL(string: "https://ubonmed.pandascoding.com/api/order_detil/getlast_id")
   
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let LastId = (jsonObj!.value(forKey: "detail_id")!) as! Int
                
                
                OperationQueue.main.addOperation({
                    print("Last ID \(LastId)")
                    self.LastID = LastId
                })
            }
        }).resume()
        
    }
    
    
    //Post API
    func PostOrderDetail(){
        var i = 0
        var SQldata = ""
        while i < appDelegate.OrderData.count {
            let sumPrice = Int(appDelegate.OrderData[i]["Pprice"]!)! * Int(appDelegate.OrderData[i]["Pamount"]!)!
            
            if i == appDelegate.OrderData.count-1 {
                
                SQldata = SQldata + "(\(LastID),\(appDelegate.OrderData[i]["Pid"]!),\(appDelegate.OrderData[i]["Pchoose"]!),\(appDelegate.OrderData[i]["Pamount"]!),\(sumPrice))"
                
            }else{
                
              SQldata = SQldata + "(\(LastID),\(appDelegate.OrderData[i]["Pid"]!),\(appDelegate.OrderData[i]["Pchoose"]!),\(appDelegate.OrderData[i]["Pamount"]!),\(sumPrice)),"
            }
            
            i = i + 1
        }
        
        let data: [String: Any] = [
            "sql_detail": "\(SQldata)",
        ]
        
        let urlString = "https://ubonmed.pandascoding.com/api/order_detil/add"
        
        Alamofire.request(urlString, method: .post, parameters: data ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                //print("NSS \(response)")
                print("Add Order_detatil Success")
                self.PostOrder()
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    
    //Post API
    func PostOrder(){
       
        
        var i = 0
        var sumPrice = 0
        while i < appDelegate.OrderData.count {
            
            sumPrice = sumPrice  + (Int(appDelegate.OrderData[i]["Pprice"]!)! * Int(appDelegate.OrderData[i]["Pamount"]!)!)
            
            i = i + 1
        }
        
        let data: [String: Any] = [
            "order_detail": "\(LastID)",
            "order_price": sumPrice,
            "order_ship_fee": 0,
            "order_discount": 0,
            "order_customer": "\(appDelegate.UserDetail["username"]!)",
            "order_address_id": appDelegate.AddressUse["Aid"]!,
        ]
        
        let urlString = "https://ubonmed.pandascoding.com/api/order/add"
        
        Alamofire.request(urlString, method: .post, parameters: data ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                //print(response)
                
                 print("Add Order Success")
                
                self.getLastid()
                
                let object = response.result.value as? [String:Any]
                let name = (object!["id"]! as? String)!
                self.InvCode = name
                self.uploadImageSlip()
                 
                 
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    func uploadImageSlip(){
    
        let urlString = "https://ubonmed.pandascoding.com/api/payment/upload"
        
        
        let image = ImageSlip
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = image.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "filetoupload", fileName: "file.png", mimeType: "image/png")
            }
            
           }, to: urlString, method: .post, headers: nil,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                    
                            print("Upload slip Success")
                         
                            let object = response.result.value as? [String:Any]
                            let name = (object!["id"]! as? String)!
                            self.nameImageSlip = name
                            self.PostPayment()
                            
                        
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
        })
        
    }
    
    
    
    func PostPayment(){
        
        var i = 0
        var sumPrice = 0
        while i < appDelegate.OrderData.count {
            
            sumPrice = sumPrice  + (Int(appDelegate.OrderData[i]["Pprice"]!)! * Int(appDelegate.OrderData[i]["Pamount"]!)!)
            
            i = i + 1
        }
        
        let data: [String: Any] = [
            "payment_order": "\(InvCode)",
            "image": "\(nameImageSlip)",
            "payment_total": sumPrice,
            "payment_account": appDelegate.BankData[selectBank]["transfer_id"]!,
            "payment_username": "\(appDelegate.UserDetail["username"]!)",
            ]
        
        let urlString = "https://ubonmed.pandascoding.com/api/payment/add"
        
        Alamofire.request(urlString, method: .post, parameters: data ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                //print(response)
                print("add Payment Success")
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    
    
    
    @IBAction func PictureCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.ImageShow.contentMode = .scaleAspectFit

            self.ImageShow.image = pickedImage
            
             ImageSlip = pickedImage
//            LabelHide.isHidden = true
//            ImgHide.isHidden = true
            choose2 = true
        }

        dismiss(animated: true, completion: nil)

        if choose1 == true && choose2 == true {
            BTfinish.isEnabled = true
            BTfinish.backgroundColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        TableHeight.constant = CGFloat(appDelegate.BankData.count) * 80.0
        
        return appDelegate.BankData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BankCell
        
       
        cell.BankId.text = "เลขที่บัญชี \(appDelegate.BankData[indexPath.item]["transfer_account"]!)"
        cell.NameBank.text = "ชื่อบัญชี \(appDelegate.BankData[indexPath.item]["transfer_name"]!)"
        cell.BankType.text = "ธนาคาร\(appDelegate.BankData[indexPath.item]["bank_name"]!)"
       
        let url = URL(string: "https://ubonmed.pandascoding.com/images/bank/\(appDelegate.BankData[indexPath.item]["bank_picture"]!)")
        let data = try? Data(contentsOf: url!)
        cell.ImageBank.image = UIImage(data: data!)
        
        cell.ImageSelect.layer.cornerRadius = 10
        
       // cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 5;
        cell.layer.borderColor = UIColor.white.cgColor
        
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! BankCell
        //selectedCell.contentView.layer.cornerRadius = 10.0
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.green.cgColor
        cell.ImageSelect.image = UIImage(named: "icon_check3")
        selectBank = indexPath.item
        
        choose1 = true
        
        if choose1 == true && choose2 == true {
            BTfinish.isEnabled = true
            BTfinish.backgroundColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        }
    
    }
    
    // Just set it back in deselect
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         let cell = self.tableView.cellForRow(at: indexPath) as! BankCell
        cell.contentView.layer.borderWidth = 0.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.ImageSelect.image = UIImage(named: "asdasd")
       
    }
  
    @IBAction func sendPayment(_ sender: Any) {
     print("Send Payment Click")
        
        
     self.PostOrderDetail()
        

     performSegue(withIdentifier: "goAlert", sender: nil)
     
        
    }
    
    
  
    
}
