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
    @IBOutlet weak var replyToPost:UIButton!
    @IBOutlet weak var mainTextViewPost: UITextView?
    
    
    @IBAction func feelingsAboutPost(_ sender: Any) {
        likedOrNotLiked.tintColor = likedOrNotLiked.tintColor == .red ? .systemBlue : .red
    }
}




class PostComment:UITableViewCell {
    
    @IBOutlet weak var postComment:UITextView!
    @IBOutlet weak var userLabel:UILabel!
    @IBOutlet weak var timeOfPost:UILabel!
    @IBOutlet weak var numberOfComments: UIButton!
    @IBOutlet weak var goodRating: UIButton!
    @IBOutlet weak var badRating: UIButton!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var postOptions: UILabel!
    

    
    
    //setup post/commentView
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        contentView.addShadow()
        
    }
}
