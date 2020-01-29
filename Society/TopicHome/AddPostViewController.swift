//
//  AddPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var topicToBePostedTo: UILabel!
    @IBOutlet weak var userStory: UITextView!
    @IBOutlet weak var isCommentAllowed: UISwitch!
    public var topicPassed:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()

        topicToBePostedTo.text = topicPassed
        topicToBePostedTo.font = .monospacedDigitSystemFont(ofSize: 24, weight: .medium)
        
        userStory.delegate = self
        userStory.text = "Please share.."
        userStory.textColor = UIColor.lightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save options incase they come back to it
        print("happening")
    }
    
    @IBAction func postingBtn(_ sender: Any) {
        //clear options if posted
        dismiss(animated: true)
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
    
}
