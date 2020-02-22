//
//  getComments.swift
//  Society
//
//  Created by Simon Tekeste on 2/8/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase


class GetComment {
    var commentCount:Int?
    var commentKey:String?
    var flagged:Bool?
    var theComment:String?
    var timeOfPost:TimeInterval?
//    var liked:Bool?
//    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    var createdByUsername:String?
    var allowComments:Bool?
    var topic:String?
    var usersthatliked:String?
    
    init(snapshot: DataSnapshot) {
        self.commentKey = snapshot.key
        let obj = snapshot.value as! NSDictionary
//        self.commentCount = Int(snapshot.childrenCount)
        self.flagged = obj["flagged"] as? Bool
        self.theComment = obj["thecomment"] as? String
        self.allowComments = obj["allowcomments"] as? Bool
        self.timeOfPost = obj["timeofpost"] as? TimeInterval
//        self.liked = obj["liked"] as? Bool
//        self.trash = obj["trash"] as? Bool
        self.likedCount = obj["likedcount"] as? Int
        self.trashCount = obj["trashcount"] as? Int
        self.createdByUsername = obj["createdbyusername"] as? String
        self.topic = obj["topic"] as? String
        let c = obj["usersthatliked"] as? NSDictionary
        self.usersthatliked = c?[currentUserID as Any] as? String
        

    }
}
