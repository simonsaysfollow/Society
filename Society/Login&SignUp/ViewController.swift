//
//  ViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.attributedPlaceholder = "Username".textPlaceHolder()
        userName.addBottomBorder(borderWidth: 2)
        password.attributedPlaceholder = "Password".textPlaceHolder()
        password.addBottomBorder(borderWidth: 2)
        
    }

    @IBAction func loginBtn(_ sender: Any) {
        self.present(categoryHome,animated: true)
    }
}

