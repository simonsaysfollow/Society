//
//  DataSnapShot.swift
//  Society
//
//  Created by Simon Tekeste on 1/30/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class DataTopicModel {
   
    var topicLabel:String?
    var topicDescription:String?
    var flagged:Bool?
    
    init?(snapshot:NSDictionary) {
        self.topicLabel = snapshot["topiclabel"] as? String
        self.topicDescription = snapshot["topicdescription"] as? String
        let flag = snapshot["whoflagged"] as? NSDictionary
        let isFlagged = flag?[currentUserID!] as?
            Bool != true ? false : true
        self.flagged = isFlagged
    }
}
