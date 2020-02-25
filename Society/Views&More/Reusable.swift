//
//  Reusable.swift
//  Society
//
//  Created by Simon Tekeste on 2/1/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

public class Resuable {
    fileprivate var emailString:String = "@society.com"
    
    func removeEmailString(username:String) -> String {
        return username.replacingOccurrences(of: emailString, with: "")
    }
    
    func appendingEmailFormat(text:String) -> String  {
        var newText = text
        newText.append(emailString)
        return newText
    }
    
    func addHashtag(topic:String) -> String {
        return "#\(topic)"
    }
    
    func removeHashTag(topic:String) -> String {
        return topic.replacingOccurrences(of: "#", with: "")
    }
    
    func trimTheWhiteSpace(text:String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
