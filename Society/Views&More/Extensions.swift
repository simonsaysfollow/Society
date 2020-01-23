//
//  Extensions.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addBottomBorder(borderWidth:CGFloat){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 4, width: self.frame.size.width, height: 2 )
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}


extension String {
    func textPlaceHolder() -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.foregroundColor: UIColor.white])
    }
}


