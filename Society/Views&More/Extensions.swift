//
//  Extensions.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}

extension UITextField {
    
    func addBottomBorder(borderWidth:CGFloat, colorSwitch:Int?){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 4, width: self.frame.size.width, height: 2 )
        if colorSwitch == 2 { bottomLine.backgroundColor = UIColor.red.cgColor } else {
            bottomLine.backgroundColor = UIColor.white.cgColor
        }
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}


extension String {
    func textPlaceHolder() -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.foregroundColor: UIColor.white])
    }
}

extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
        
    }
}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class ReusableComponents:UIViewController {
    
    public func filteringOptions(viewController:UIViewController, tableView:UITableView) {

        let alert = UIAlertController(title: "", message: "How would you like to filter?", preferredStyle: .actionSheet)
              
        let liked = UIAlertAction(title: "Most likes", style: .default) { (UIAlertAction) in
            print("This filtered by likes")
            
        }
        let ascending = UIAlertAction(title: "Ascending", style: .default) {
            (UIAlertAction) in
             print("This post will be filtered by ascending order")
            
        }
        
        let descending = UIAlertAction(title: "Descending", style: .default) { (UIAlertAction) in
            print("This post will be filtered by descending order ")
            tableView.separatorColor = .red
//           tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
      
        alert.addAction(liked)
        alert.addAction(ascending)
        alert.addAction(descending)
        alert.addAction(cancel)
    
        viewController.present(alert,animated: true)
    }
}

