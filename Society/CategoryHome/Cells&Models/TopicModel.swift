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
            return
        }
        self.topicLabel = topicLabel
        self.topicDescription = topicDescription
        self.viewController = viewController
        enteringIntoTopicCreatedDB()
    }
    
    func enteringIntoTopicCreatedDB() {
        
        let path = Resuable().removeHashTag(topic: topicLabel!)
        firebaseRef.child("topics").child(path).setValue(["topiclabel": topicLabel!, "topicdescription": topicDescription!,"createdbyuser":Auth.auth().currentUser!.uid])
        viewController?.dismiss(animated: true)
        
    }
}
