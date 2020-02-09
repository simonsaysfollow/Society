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
    public var postKey:String?
    
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
        //store data so even if they go back they have it
        print("happening")
    }
    
    @IBAction func postingBtn(_ sender: Any) {
        //clear options if posted
        addPostPerTopic()
        dismiss(animated: true)
    }
    
    func addPostPerTopic() {
        let topicDB = TopicViewController().removeHashTag(topic: topicPassed!)
        
        if topicPassed == "anything"{
            
            _ =  AddComments(postYourRespondingToKey: postKey! , topic: topicDB, theComment: userStory.text , createdByUsername: Resuable().removeEmailString(username: (Auth.auth().currentUser?.email)!), allowComments: isCommentAllowed.isOn, viewController:self)
            
        }else {
            
           _ = TopicPostModel(topic: topicDB, thePost: userStory.text, createdBy: Auth.auth().currentUser!.uid, allowComments: isCommentAllowed.isOn, createdByUsername: Resuable().removeEmailString(username: (Auth.auth().currentUser?.email)!),viewController: self)
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
