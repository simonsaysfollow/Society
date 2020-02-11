//
//  TopicModel.swift
//  Society
//
//  Created by Simon Tekeste on 1/28/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class TopicModel {
    var topicLabel:String?
    var topicDescription:String?
    var viewController:UIViewController?
    
    init(topicLabel:String,topicDescription:String,viewController:UIViewController) {
        if topicLabel.isEmpty || topicDescription.isEmpty {
            print("No field can be empty")
            return
        }
        self.topicLabel = topicLabel
        self.topicDescription = topicDescription
        self.viewController = viewController
        enteringIntoTopicCreatedDB()
    }
    
    func enteringIntoTopicCreatedDB() {
//        firebaseRef.child("Topics").childByAutoId().setValue(["topiclabel": topicLabel!, "topicdescription": topicDescription!,"createdbyuser":Auth.auth().currentUser!.uid, "flagged":false])
//        viewController?.dismiss(animated: true)
        
        let path = Resuable().removeHashTag(topic: topicLabel!)
        firebaseRef.child("Topics").child(path).setValue(["topiclabel": topicLabel!, "topicdescription": topicDescription!,"createdbyuser":Auth.auth().currentUser!.uid, "flagged":false])
        viewController?.dismiss(animated: true)
        
    }
}
