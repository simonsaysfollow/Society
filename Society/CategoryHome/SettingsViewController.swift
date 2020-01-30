//
//  SettingsViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/28/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    //MARK:IBOutlets 
    @IBOutlet weak var signOut:UIBarButtonItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signOut.image = UIImage(named: "peaceOut")!.withRenderingMode(.alwaysOriginal)
    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
             present(mainHome,animated: true)
        } catch let error {
            print("Cannot Sign out \n \(error)")
        }
    }
    
}
