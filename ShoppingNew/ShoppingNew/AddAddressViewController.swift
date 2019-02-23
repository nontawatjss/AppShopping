//
//  AddAddressViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 4/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire

class AddAddressViewController: UIViewController {

    @IBOutlet weak var ViewForm: UIView!
    

    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var District: UITextField!
    @IBOutlet weak var District2: UITextField!
    @IBOutlet weak var Province: DropDown!
    @IBOutlet weak var Code: UITextField!
    
    @IBOutlet weak var BTAddAddress: UIButton!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let changwat = [
    [
    "pid": "10",
    "name": "กรุงเทพมหานคร"
    ],
    [
    "pid": "11",
    "name": "สมุทรปราการ"
    ],
    [
    "pid": "12",
    "name": "นนทบุรี"
    ],
    [
    "pid": "13",
    "name": "ปทุมธานี"
    ],
    [
    "pid": "14",
    "name": "พระนครศรีอยุธยา"
    ],
    [
    "pid": "15",
    "name": "อ่างทอง"
    ],
    [
    "pid": "16",
    "name": "ลพบุรี"
    ],
    [
    "pid": "17",
    "name": "สิงห์บุรี"
    ],
    [
    "pid": "18",
    "name": "ชัยนาท"
    ],
    [
    "pid": "19",
    "name": "สระบุรี"
    ],
    [
    "pid": "20",
    "name": "ชลบุรี"
    ],
    [
    "pid": "21",
    "name": "ระยอง"
    ],
    [
    "pid": "22",
    "name": "จันทบุรี"
    ],
    [
    "pid": "23",
    "name": "ตราด"
    ],
    [
    "pid": "24",
    "name": "ฉะเชิงเทรา"
    ],
    [
    "pid": "25",
    "name": "ปราจีนบุรี"
    ],
    [
    "pid": "26",
    "name": "นครนายก"
    ],
    [
    "pid": "27",
    "name": "สระแก้ว"
    ],
    [
    "pid": "30",
    "name": "นครราชสีมา"
    ],
    [
    "pid": "31",
    "name": "บุรีรัมย์"
    ],
    [
    "pid": "32",
    "name": "สุรินทร์"
    ],
    [
    "pid": "33",
    "name": "ศรีสะเกษ"
    ],
    [
    "pid": "34",
    "name": "อุบลราชธานี"
    ],
    [
    "pid": "35",
    "name": "ยโสธร"
    ],
    [
    "pid": "36",
    "name": "ชัยภูมิ"
    ],
    [
    "pid": "37",
    "name": "อำนาจเจริญ"
    ],
    [
    "pid": "38",
    "name": "บึงกาฬ"
    ],
    [
    "pid": "39",
    "name": "หนองบัวลำภู"
    ],
    [
    "pid": "40",
    "name": "ขอนแก่น"
    ],
    [
    "pid": "41",
    "name": "อุดรธานี"
    ],
    [
    "pid": "42",
    "name": "เลย"
    ],
    [
    "pid": "43",
    "name": "หนองคาย"
    ],
    [
    "pid": "44",
    "name": "มหาสารคาม"
    ],
    [
    "pid": "45",
    "name": "ร้อยเอ็ด"
    ],
    [
    "pid": "46",
    "name": "กาฬสินธุ์"
    ],
    [
    "pid": "47",
    "name": "สกลนคร"
    ],
    [
    "pid": "48",
    "name": "นครพนม"
    ],
    [
    "pid": "49",
    "name": "มุกดาหาร"
    ],
    [
    "pid": "50",
    "name": "เชียงใหม่"
    ],
    [
    "pid": "51",
    "name": "ลำพูน"
    ],
    [
    "pid": "52",
    "name": "ลำปาง"
    ],
    [
    "pid": "53",
    "name": "อุตรดิตถ์"
    ],
    [
    "pid": "54",
    "name": "แพร่"
    ],
    [
    "pid": "55",
    "name": "น่าน"
    ],
    [
    "pid": "56",
    "name": "พะเยา"
    ],
    [
    "pid": "57",
    "name": "เชียงราย"
    ],
    [
    "pid": "58",
    "name": "แม่ฮ่องสอน"
    ],
    [
    "pid": "60",
    "name": "นครสวรรค์"
    ],
    [
    "pid": "61",
    "name": "อุทัยธานี"
    ],
    [
    "pid": "62",
    "name": "กำแพงเพชร"
    ],
    [
    "pid": "63",
    "name": "ตาก"
    ],
    [
    "pid": "64",
    "name": "สุโขทัย"
    ],
    [
    "pid": "65",
    "name": "พิษณุโลก"
    ],
    [
    "pid": "66",
    "name": "พิจิตร"
    ],
    [
    "pid": "67",
    "name": "เพชรบูรณ์"
    ],
    [
    "pid": "70",
    "name": "ราชบุรี"
    ],
    [
    "pid": "71",
    "name": "กาญจนบุรี"
    ],
    [
    "pid": "72",
    "name": "สุพรรณบุรี"
    ],
    [
    "pid": "73",
    "name": "นครปฐม"
    ],
    [
    "pid": "74",
    "name": "สมุทรสาคร"
    ],
    [
    "pid": "75",
    "name": "สมุทรสงคราม"
    ],
    [
    "pid": "76",
    "name": "เพชรบุรี"
    ],
    [
    "pid": "77",
    "name": "ประจวบคีรีขันธ์"
    ],
    [
    "pid": "80",
    "name": "นครศรีธรรมราช"
    ],
    [
    "pid": "81",
    "name": "กระบี่"
    ],
    [
    "pid": "82",
    "name": "พังงา"
    ],
    [
    "pid": "83",
    "name": "ภูเก็ต"
    ],
    [
    "pid": "84",
    "name": "สุราษฎร์ธานี"
    ],
    [
    "pid": "85",
    "name": "ระนอง"
    ],
    [
    "pid": "86",
    "name": "ชุมพร"
    ],
    [
    "pid": "90",
    "name": "สงขลา"
    ],
    [
    "pid": "91",
    "name": "สตูล"
    ],
    [
    "pid": "92",
    "name": "ตรัง"
    ],
    [
    "pid": "93",
    "name": "พัทลุง"
    ],
    [
    "pid": "94",
    "name": "ปัตตานี"
    ],
    [
    "pid": "95",
    "name": "ยะลา"
    ],
    [
    "pid": "96",
    "name": "นราธิวาส"
    ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "เพิ่มข้อมูลที่อยู่"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
       
        ViewForm.layer.cornerRadius = 5.0
        BTAddAddress.layer.cornerRadius = 5.0
        
        Fname.isEnabled = false
        Lname.isEnabled = false
        Fname.text = appDelegate.UserDetail["fname"]!
        Lname.text = appDelegate.UserDetail["lname"]!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Province.optionArray = []
        //Its Id Values and its optional
        Province.optionIds = [0,1,2]
        
        
        loadProviceList()
      
        
    }
    
    
    func loadProviceList(){
        var i = 0
        
        while i < changwat.count {
            Province.optionArray.append("\(changwat[i]["name"]!)")
            Province.optionIds?.append(Int(changwat[i]["pid"]!)!)
            
            i = i + 1
        }
        
        
        
    }
    
    
    //Post API
    func addAddress(Aname:String,Aline1:String,Aline2:String,Atambon:String,Aamphoe:String,Aprovince:String,Acode:String, Ausername:String){
        
        print("Okk")
        
        let data: [String: Any] = [
            "address_line1": Aline1,
            "address_line2": "",
            "address_tambon": Atambon,
            "address_amphoe" : Aamphoe,
            "address_province": Aprovince,
            "address_zipcode": Acode,
            "address_customer": Ausername
        ]
        
        let urlString = "https://ubonmed.pandascoding.com/api/address/add"
        
        Alamofire.request(urlString, method: .post, parameters: data ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                print("Success! New Account")
                self.AlertSuccess()
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    
    func AlertSuccess() {
        
        
        let attributedString = NSAttributedString(string: "Success add Address", attributes: [
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
            self.navigationController?.popViewController(animated: true)
            self.setEmptyText()
        }
        
    }
    
    
    func setEmptyText(){
    
        Fname.text = ""
        Lname.text = ""
        Address.text = ""
        District.text = ""
        District2.text = ""
        Province.text = ""
        Code.text = ""

    }
    
    
    @IBAction func BTAdd(_ sender: Any) {
        
       
        addAddress(Aname: "\(Fname.text!) \(Lname.text!)", Aline1: "\(Address.text!)", Aline2: "line2", Atambon: "\(District.text!)", Aamphoe: "\(District2.text!)", Aprovince: "\(Province.text!)", Acode: "\(Code.text!)", Ausername: "\(appDelegate.UserDetail["username"]!)")
    
    
        
    }
    
}
