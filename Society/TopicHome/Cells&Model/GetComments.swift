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
    var liked:Bool?
    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    var createdByUsername:String?
    var allowComments:Bool?
    
    init(snapshot: DataSnapshot) {
        self.commentCount = Int(snapshot.childrenCount)
        if snapshot.exists() {
          self.commentKey = snapshot.key
          let obj = snapshot.value as! NSDictionary
  
          self.flagged = obj["flagged"] as? Bool
          self.theComment = obj["thecomment"] as? String
          self.allowComments = obj["allowcomments"] as? Bool
          self.timeOfPost = obj["timeofpost"] as? TimeInterval
          self.liked = obj["liked"] as? Bool
          self.trash = obj["trash"] as? Bool
          self.likedCount = obj["likedcount"] as? Int
          self.trashCount = obj["trashcount"] as? Int
          self.createdByUsername = obj["createdbyusername"] as? String
            
        }
    }
}
