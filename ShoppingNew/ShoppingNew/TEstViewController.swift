//
//  TEstViewController.swift
//  ShoppingNew
//
//  Created by Nontawat on 21/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit


class TEstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Text1: UITextField!
    
    @IBOutlet weak var Text2: UITextField!
    @IBOutlet weak var ScrollV: UIScrollView!
    @IBOutlet weak var ViewForm: UIView!
    @IBOutlet weak var HView: NSLayoutConstraint!
    
    var i = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
        
        registerForKeyboardNotifications()
   
    }
    

   
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        ScrollV.contentInset = insets
        ScrollV.scrollIndicatorInsets = insets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        let activeField: UITextField? = [Text1, Text2].first { $0.isFirstResponder }
        if let activeField = activeField {
            if aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                ScrollV.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        ScrollV.contentInset = UIEdgeInsets.zero
        ScrollV.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    

}
