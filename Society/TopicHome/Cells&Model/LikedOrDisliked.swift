//
//  LikedOrDisliked.swift
//  Society
//
//  Created by Simon Tekeste on 2/15/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class Liked {
    var key:String?
    var liked:Bool?
    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    
    init(snapshot:DataSnapshot, key:String ) {
        self.key = key
        let obj = snapshot.value as! NSDictionary
        
        self.liked = obj["liked"] as? Bool
        self.trash = obj["trash"] as? Bool
        self.likedCount = obj["likedcount"] as? Int
        self.trashCount = obj["trashcount"] as? Int
        self.changeCount()
    }
    

    func changeCount() {
        firebaseRef.child("comments").child(key!).observeSingleEvent(of: .value) { (snapShot) in
         let obj = snapShot.value as? NSDictionary
    
            let getUserFeelings = obj?["usersthatliked"] as? NSDictionary
            
            
            if getUserFeelings?[currentUserID!] as? String == "" || getUserFeelings == nil {
               var count = obj!["likedcount"] as? Int
                count = count! + 1
                firebaseRef.child("comments").child(self.key!).updateChildValues(["likedcount":count!])
            }
            
            
            if getUserFeelings?[currentUserID!] as? String == "disliked" {
                
                var count = obj!["likedcount"] as? Int
                count = count! + 1
                firebaseRef.child("comments").child(self.key!).updateChildValues(["likedcount":count!])
                
                var countDec = obj!["trashcount"] as! Int
                countDec = countDec - 1
                firebaseRef.child("comments").child(self.key!).updateChildValues(["trashcount":countDec])
                

            }
            firebaseRef.child("comments").child(self.key!).updateChildValues(["usersthatliked":[Auth.auth().currentUser?.uid:"liked"]])
        }
    }
}


class Disliked {
    var key:String?
    var liked:Bool?
    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    
    init(snapshot:DataSnapshot, key:String ) {
        self.key = key
        let obj = snapshot.value as! NSDictionary
        
        self.liked = obj["liked"] as? Bool
        self.trash = obj["trash"] as? Bool
        self.likedCount = obj["likedcount"] as? Int
        self.trashCount = obj["trashcount"] as? Int
        self.changeCount()
    }
    
    func changeCount() {
        
        firebaseRef.child("comments").child(key!).observeSingleEvent(of: .value) { (snapShot) in
            let obj = snapShot.value as? NSDictionary

            let getUserFeelings = obj?["usersthatliked"] as? NSDictionary
            
            
            if getUserFeelings?[currentUserID!] as? String == "" || getUserFeelings == nil {
                
                var count = obj!["trashcount"] as! Int
                count = count + 1
                firebaseRef.child("comments").child(self.key!).updateChildValues(["trashcount":count])
                
            }
            
            if getUserFeelings?[currentUserID!] as? String == "liked" {
                
                var count = obj!["trashcount"] as! Int
                count = count + 1
                firebaseRef.child("comments").child(self.key!).updateChildValues(["trashcount":count])
                
                var countDec = obj!["likedcount"] as? Int
                countDec = countDec! - 1
                firebaseRef.child("comments").child(self.key!).updateChildValues(["likedcount":countDec!])
                
                    
            }
            firebaseRef.child("comments").child(self.key!).updateChildValues(["usersthatliked":[Auth.auth().currentUser?.uid:"disliked"]])
            
        }
        
    }
    
}

