//
//  SettingsViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/28/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK:IBOutlets 
    @IBOutlet weak var signOut:UIBarButtonItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        signOut.image = UIImage(named: "peaceOut")!.withRenderingMode(.alwaysOriginal)
    }
    @IBAction func signOutBtn(_ sender: Any) {
        
        present(mainHome,animated: true)
    }
    
}
