//
//  TopicPostModel.swift
//  Society
//
//  Created by Simon Tekeste on 1/31/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class TopicPostModel {
    var viewController:UIViewController?
    
    var topic:String?
    var flagged:Bool = false
    var thePost:String?
    var timeOfPost = ServerValue.timestamp()
    var liked:Bool = false
    var trash:Bool = false
    var likedCount:Int = 0
    var trashCount:Int = 0
    var createdBy:String?  // this should be email
    var createdByUsername:String?
    var allowComments:Bool?
//var comments:[Comments]
//add who trashed and who liked
    
    init(topic:String,thePost:String,createdBy:String,allowComments:Bool, createdByUsername:String,viewController:UIViewController?) {
        
        if topic.isEmpty || thePost.isEmpty || createdBy.isEmpty || createdByUsername.isEmpty {
            return
        }
        self.topic = topic
        self.thePost = thePost
        self.createdBy = createdBy
        self.allowComments = allowComments
        self.createdByUsername = createdByUsername
        self.viewController = viewController
        self.storeTopicPostInDB()
        
    }
    
    func addHashtag(topic:String) -> String {
        return "#\(topic)"
    }
    
  fileprivate func storeTopicPostInDB() {
    
    firebaseRef.child("Society").child(topic!).childByAutoId().setValue([
        "topic":addHashtag(topic: topic!),
        "allowcomments":allowComments!,
        "flagged":flagged,
        "thepost":thePost!,
        "liked":liked,
        "trash":trash,
        "likedcount":likedCount,
        "trashcount":trashCount,
        "createdby":createdBy!,
        "createdbyusername":createdByUsername!,
        "timeofpost":timeOfPost
        ])
    { (Error, DatabaseReference) in
        
        if (Error != nil) {
            print("Houston we got a problem")
            return
        }
        self.viewController?.dismiss(animated: true)
        }
    }
}
