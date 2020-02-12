//
//  Comments.swift
//  Society
//
//  Created by Simon Tekeste on 1/31/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class AddComments {
    var postYourRespondingToKey:String?
    var topic:String?
    var flagged:Bool = false
    var theComment:String?
    var timeOfPost = ServerValue.timestamp()
    var liked:Bool = false
    var trash:Bool = false
    var likedCount:Int = 0
    var trashCount:Int = 0
    var createdByUsername:String?
    var allowComments:Bool?
    var viewController:UIViewController?
    
    init(postYourRespondingToKey:String?,topic:String?,theComment:String,createdByUsername:String,allowComments:Bool?,viewController:UIViewController?) {
        self.postYourRespondingToKey = postYourRespondingToKey
        self.topic = topic
        self.theComment = theComment
        self.createdByUsername = createdByUsername
        self.allowComments = allowComments
        self.viewController = viewController
        self.addCommentsToDB()
    }
    
    func addCommentsToDB() {
        firebaseRef.child("comments").childByAutoId().setValue(
            [
                "postyourrespondingtokey":self.postYourRespondingToKey!,
                "topic":self.topic!,
                "allowcomments":self.allowComments!,
                "flagged":self.flagged,
                "thecomment":self.theComment!,
                "liked":self.liked,
                "trash":self.trash,
                "likedcount":self.likedCount,
                "trashcount":self.trashCount,
                "createdbyusername":self.createdByUsername!,
                "timeofpost":self.timeOfPost,
                
            ]
            
            , withCompletionBlock: { (Error, success) in
                if Error != nil {
                    print(Error!)
                    return;
                    }
            })
        viewController?.dismiss(animated: true)
    }
}
