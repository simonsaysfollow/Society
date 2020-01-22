//
//  Cell.swift
//  Society
//
//  Created by Simon Tekeste on 1/18/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit



class PostsCell:UITableViewCell {
    
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var thePosts: UILabel!
    @IBOutlet weak var minutesPosted: UILabel!
    @IBOutlet weak var postSettingsBtn: UIButton!
    @IBOutlet weak var likedOrNotLiked: UIButton!
    
    
    @IBAction func feelingsAboutPost(_ sender: Any) {
        likedOrNotLiked.tintColor = likedOrNotLiked.tintColor == .red ? .systemBlue : .red
    }
   
    
}

