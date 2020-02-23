//
//  AddPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var topicToBePostedTo: UILabel!
    @IBOutlet weak var userStory: UITextView!
    @IBOutlet weak var isCommentAllowed: UISwitch!
    
    public var topicPassed:String?
    public var topicPassedFromCategory:String?
    public var postKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()
    
        topicToBePostedTo.text = topicPassed
        
        if topicPassedFromCategory != nil {
          topicToBePostedTo.text = topicPassedFromCategory
        }
        
        topicToBePostedTo.font = .monospacedDigitSystemFont(ofSize: 24, weight: .medium)
        
        userStory.delegate = self
        userStory.text = "Please share.."
        userStory.textColor = UIColor.lightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //store data so even if they go back they have it
        print("happening")
    }
    
    @IBAction func postingBtn(_ sender: Any) {
        //clear options if posted
        addPostPerTopic()
        dismiss(animated: true)
    }
    
    func addPostPerTopic() {
        var topicDB:String?
        if topicPassedFromCategory != nil {
            topicDB = Resuable().removeHashTag(topic: topicPassedFromCategory!)
        }else {
         topicDB = Resuable().removeHashTag(topic: topicPassed!)
        }
       
        if topicPassedFromCategory != nil {
    
            _ = TopicPostModel(topic: topicDB!, thePost: userStory.text, createdBy: Auth.auth().currentUser!.uid, allowComments: isCommentAllowed.isOn, createdByUsername: Resuable().removeEmailString(username: (Auth.auth().currentUser?.email)!),viewController: self)
            
        }else {
         
             _ =  AddComments(postYourRespondingToKey: postKey! , topic: topicDB, theComment: userStory.text , createdByUsername: Resuable().removeEmailString(username: (Auth.auth().currentUser?.email)!), allowComments: isCommentAllowed.isOn, viewController:self)
            
        }
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
