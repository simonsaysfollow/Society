//
//  GetTopicPost.swift
//  Society
//
//  Created by Simon Tekeste on 2/1/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class GetTopicPost {
    var topicKey:String?
    var topic:String?
    var flagged:Bool?
    var thePost:String?
    var timeOfPost:TimeInterval?
    var liked:Bool?
    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    var createdByUsername:String?
    var allowComments:Bool?
//    lazy var comments = [Comments]()
    
    init(snapshot:DataSnapshot) {
       if snapshot.exists() {
        
        self.topicKey = snapshot.key
        let obj = snapshot.value as! NSDictionary
       
        self.topic = obj["topic"] as? String
        self.flagged = obj["flagged"] as? Bool
        self.thePost = obj["thepost"] as? String
        self.liked = obj["liked"] as? Bool
        self.trash = obj["trash"] as? Bool
        self.likedCount = obj["likedcount"] as? Int
        self.trashCount =  obj["trashcount"] as? Int
        self.createdByUsername =  obj["createdbyusername"] as? String
        self.allowComments =  obj["allowcomments"] as? Bool
        self.timeOfPost = (obj["timeofpost"] as? TimeInterval)!

        }
    }
}

