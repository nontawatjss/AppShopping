//
//  ContactViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 28/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit
import MapKit

class ContactViewController: UIViewController {

    @IBOutlet weak var LogoImage: UIImageView!
    
    @IBOutlet weak var AddressText: UITextView!
    
    @IBOutlet weak var View2: UIView!
    
    @IBOutlet weak var View3: UIView!
    
    @IBOutlet weak var TelImage1: UIImageView!
    
    
    @IBOutlet weak var TelImage2: UIImageView!
    
    @IBOutlet weak var LineImage: UIImageView!
    
    @IBOutlet weak var MapShow: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        navigationItem.title = "เกี่ยวกับเรา"
        
        View2.layer.cornerRadius = 5.0
        View3.layer.cornerRadius = 5.0
        
        
        ReloadView()

       
    }
    
    func ReloadView() {
        
        LogoImage.layer.cornerRadius = 5.0
        
        LoadMap()
        
        AddressText.text = "ไทย เมดิคอล เทรดดิ้ง \nบ้านเลขที่ 17/1 ถนน ราษฏร์บำรุง ซอยราษฏร์บำรุง 4 \nตำบล ในเมือง อำเภอ เมือง จังหวัด อุบลราชธานี 34000"
        
        
        
    }
    
    func LoadMap() {
        
        MapShow.layer.cornerRadius = 5.0
        MapShow.mapType = MKMapType.standard
        
        // 2)15.272579, 104.842323
        let location = CLLocationCoordinate2D(latitude: 15.272579,longitude: 104.842323)
        
        // 3)
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapShow.setRegion(region, animated: true)
        
        // 4)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "UbonMed"
        annotation.subtitle = "อุปกรณ์การแพทย์"
        MapShow.addAnnotation(annotation)
        
        let longTapGesture = UITapGestureRecognizer(target: self, action: #selector(openMapForPlace))
        MapShow.addGestureRecognizer(longTapGesture)
        
    }
    
    

    
    

    
    
   @objc func openMapForPlace() {
        
        let latitude:CLLocationDegrees =  15.272579
        let longitude:CLLocationDegrees =  104.842323
        
        
        let regionDistance:CLLocationDistance = 5000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "UbonMed"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
}
