    //
//  Views.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase
    
let main = UIStoryboard(name: "Main", bundle: nil)
let category = UIStoryboard(name: "Category", bundle: nil)
let topic = UIStoryboard(name: "Topic", bundle: nil)
var firebaseRef = Database.database().reference()

    
var mainHome: UINavigationController  {
    let home = main.instantiateInitialViewController() as! UINavigationController
    home.modalPresentationStyle = .fullScreen
    return home
    
}

var categoryHome: UINavigationController  {
    let ch = category.instantiateInitialViewController() as! UINavigationController
    ch.modalPresentationStyle = .fullScreen
    return ch
    
}

var topicHome: UINavigationController  {
    let tp = topic.instantiateInitialViewController() as! UINavigationController
    tp.modalPresentationStyle = .fullScreen
    return tp
    
}

