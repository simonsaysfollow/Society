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
    var path:String?
    var key:String?
    var liked:Bool?
    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    var topic:String?
    
    init(snapshot:DataSnapshot, key:String, path:String ) {
        self.key = key
        self.path = path
        let obj = snapshot.value as! NSDictionary
        
        
        self.topic = Resuable().removeHashTag(topic: obj["topic"] as! String)
        self.liked = obj["liked"] as? Bool
        self.trash = obj["trash"] as? Bool
        self.likedCount = obj["likedcount"] as? Int
        self.trashCount = obj["trashcount"] as? Int
        
        if path == "comments" {
            self.likeComment()
        }
        else {
            self.likeHeader()
        }
        
    }
    

    func likeComment() {
        firebaseRef.child(self.path!).child(key!).observeSingleEvent(of: .value) { (snapShot) in
         let obj = snapShot.value as? NSDictionary
        
            let getUserFeelings = obj?["usersthatliked"] as? NSDictionary
            
            
            if getUserFeelings?[currentUserID!] as? String == "" || getUserFeelings == nil {
               var count = obj!["likedcount"] as? Int
                count = count! + 1
                firebaseRef.child(self.path!).child(self.key!).updateChildValues(["likedcount":count!])
            }
            
            
            if getUserFeelings?[currentUserID!] as? String == "disliked" {
                
                var count = obj!["likedcount"] as? Int
                count = count! + 1
                firebaseRef.child(self.path!).child(self.key!).updateChildValues(["likedcount":count!])
                
                var countDec = obj!["trashcount"] as! Int
                countDec = countDec - 1
                firebaseRef.child(self.path!).child(self.key!).updateChildValues(["trashcount":countDec])
                

            }
            firebaseRef.child(self.path!).child(self.key!).updateChildValues(["usersthatliked":[Auth.auth().currentUser?.uid:"liked"]])
        }
    }
    
    func likeHeader() {
        
        firebaseRef.child(self.path!).child(self.topic!).child(key!).observeSingleEvent(of: .value) { (snapShot) in
             let obj = snapShot.value as? NSDictionary
        
                let getUserFeelings = obj?["usersthatliked"] as? NSDictionary
                
                if getUserFeelings?[currentUserID!] as? String == "" || getUserFeelings == nil {
                   var count = obj?["likedcount"] as? Int
                    count = count! + 1
                    firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["likedcount":count!])
                }
                
                
                if getUserFeelings?[currentUserID!] as? String == "disliked" {
                    
                    var count = obj!["likedcount"] as? Int
                    count = count! + 1
                    firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["likedcount":count!])
                    
                    var countDec = obj!["trashcount"] as! Int
                    countDec = countDec - 1
                    firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["trashcount":countDec])
                    

                }
                firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["usersthatliked":[Auth.auth().currentUser?.uid:"liked"]])
            }
        
    }
}


class Disliked {
    var path:String?
    var key:String?
    var liked:Bool?
    var trash:Bool?
    var likedCount:Int?
    var trashCount:Int?
    var topic:String?
    
    init(snapshot:DataSnapshot, key:String, path:String ) {
        self.key = key
        self.path = path
        let obj = snapshot.value as! NSDictionary
        
        self.topic = Resuable().removeHashTag(topic: obj["topic"] as! String)
        self.liked = obj["liked"] as? Bool
        self.trash = obj["trash"] as? Bool
        self.likedCount = obj["likedcount"] as? Int
        self.trashCount = obj["trashcount"] as? Int
        
        if path == "comments" {
          self.dislikeComment()
        }else {
            self.dislikeHeader()
        }
    }
    
    func dislikeComment() {
        
        firebaseRef.child(self.path!).child(key!).observeSingleEvent(of: .value) { (snapShot) in
            let obj = snapShot.value as? NSDictionary

            let getUserFeelings = obj?["usersthatliked"] as? NSDictionary
            
            
            if getUserFeelings?[currentUserID!] as? String == "" || getUserFeelings == nil {
                
                var count = obj!["trashcount"] as! Int
                count = count + 1
                firebaseRef.child(self.path!).child(self.key!).updateChildValues(["trashcount":count])
                
            }
            
            if getUserFeelings?[currentUserID!] as? String == "liked" {
                
                var count = obj!["trashcount"] as! Int
                count = count + 1
                firebaseRef.child(self.path!).child(self.key!).updateChildValues(["trashcount":count])
                
                var countDec = obj!["likedcount"] as? Int
                countDec = countDec! - 1
                firebaseRef.child(self.path!).child(self.key!).updateChildValues(["likedcount":countDec!])
                
                    
            }
            firebaseRef.child(self.path!).child(self.key!).updateChildValues(["usersthatliked":[Auth.auth().currentUser?.uid:"disliked"]])
            
        }
        
    }
    func dislikeHeader() {
        
        firebaseRef.child(self.path!).child(self.topic!).child(key!).observeSingleEvent(of: .value) { (snapShot) in
            let obj = snapShot.value as? NSDictionary

            let getUserFeelings = obj?["usersthatliked"] as? NSDictionary
            
            if getUserFeelings?[currentUserID!] as? String == "" || getUserFeelings == nil {
                
                var count = obj?["trashcount"] as! Int
                count = count + 1
                firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["trashcount":count])
                
            }
            
            if getUserFeelings?[currentUserID!] as? String == "liked" {
                
                var count = obj!["trashcount"] as! Int
                count = count + 1
                firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["trashcount":count])
                
                var countDec = obj!["likedcount"] as? Int
                countDec = countDec! - 1
                firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["likedcount":countDec!])
                
                    
            }
            firebaseRef.child(self.path!).child(self.topic!).child(self.key!).updateChildValues(["usersthatliked":[Auth.auth().currentUser?.uid:"disliked"]])
            
        }
               
    }
    
}

