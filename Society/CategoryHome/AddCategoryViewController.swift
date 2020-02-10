//
//  AddCategoryViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/26/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryDescription: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        // Do any additional setup after loading the view.
        categoryName.layer.borderColor = UIColor.black.cgColor
        categoryName.layer.borderWidth = 1
        categoryDescription.layer.borderColor = UIColor.black.cgColor
        categoryDescription.layer.borderWidth = 1
        
        categoryDescription.delegate = self
        categoryDescription.textColor = UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
           if textView.textColor == UIColor.lightGray {
               textView.text = ""
               textView.textColor = UIColor.orange
           }
        
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {

           if textView.text == "" {
               textView.text = "Placeholder text ..."
               textView.textColor = UIColor.lightGray
           }
       }
    

    @IBAction func addCategory(_ sender: Any) {
        var topicName = categoryName.text!.components(separatedBy: .whitespacesAndNewlines).joined()
        topicName = topicName.contains("#") ? topicName : "#\(topicName)"
        _ = TopicModel(topicLabel: topicName.capitalized, topicDescription: categoryDescription.text!,viewController:self)
    }
    
}
