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
    
    init(snapshot:NSDictionary) {
        
        if snapshot.count == 0 {
            return
        }
        self.topic = snapshot["topic"] as? String
        self.flagged = snapshot["flagged"] as? Bool
        self.thePost = snapshot["thepost"] as? String
        self.liked = snapshot["liked"] as? Bool
        self.trash = snapshot["trash"] as? Bool
        self.likedCount = snapshot["likedcount"] as? Int
        self.trashCount =  snapshot["trashcount"] as? Int
        self.createdByUsername =  snapshot["createdbyusername"] as? String
        self.allowComments =  snapshot["allowcomments"] as? Bool
        self.timeOfPost = snapshot["timeofpost"] as? TimeInterval
    }
}
