//
//  AddPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var topicToBePostedTo: UILabel!
    @IBOutlet weak var userStory: UITextView!
    @IBOutlet weak var isCommentAllowed: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userStory.attributedText = "Please share..".textPlaceHolder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save options incase they come back to it
        print("happening")
    }
    
    @IBAction func postingBtn(_ sender: Any) {
        //clear options if posted
        dismiss(animated: true)
    }
}
