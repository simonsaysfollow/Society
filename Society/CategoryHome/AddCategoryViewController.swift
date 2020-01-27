//
//  AddCategoryViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/26/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryDescription: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryName.layer.borderColor = UIColor.black.cgColor
        categoryName.layer.borderWidth = 1
        categoryDescription.layer.borderColor = UIColor.black.cgColor
        categoryDescription.layer.borderWidth = 1
        
        
    }
    

    @IBAction func addCategory(_ sender: Any) {
        
    }
    
}
