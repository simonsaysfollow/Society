//
//  Flagged.swift
//  Society
//
//  Created by Simon Tekeste on 2/24/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class Flagged {
    var flagged:Bool?
    var topicName:String?
    
    init(snap: DataSnapshot, path:String) {
        let obj = snap.value as? NSDictionary
        self.topicName = Resuable().removeHashTag(topic: (obj?["topiclabel"] as? String)!)
        self.flagged = obj?["flagged"] as?  Bool
        
        firebaseRef.child(path).child(topicName!).observeSingleEvent(of: .value) { (snapshot) in
            let object = snapshot.value as? NSDictionary
            let objectUserID = object?["whoflagged"] as? NSDictionary
            let currentUserStatus =  objectUserID?[currentUserID as Any] as? Bool
            
            if currentUserStatus == false || currentUserStatus == nil {
            firebaseRef.child(path).child(self.topicName!).updateChildValues(["whoflagged":[currentUserID:true]])
            }else {
            firebaseRef.child(path).child(self.topicName!).updateChildValues(["whoflagged":[currentUserID:false]])
            }
            
            
        }
        
    }
}
