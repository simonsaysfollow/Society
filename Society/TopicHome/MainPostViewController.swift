//
//  MainPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class MainPostViewController: UIViewController {
    var numOfIndex:Int?

    @IBOutlet weak var tableViewMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
    }
    

    @objc func replyingToPost(replyToPost:UIButton) {
        print(replyToPost.tag)
        numOfIndex = replyToPost.tag
        tableViewMain.reloadData()
    }
    
    
  
    


}

extension MainPostViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        if indexPath.section == 0 {
            let cell = tableViewMain.dequeueReusableCell(withIdentifier: "mainPost") as! PostsCell
            cell.replyToPost.tag = indexPath.row
            cell.replyToPost.addTarget(self, action: #selector(replyingToPost(replyToPost:)), for: .touchDown)
            return cell
        }
        
        let comments = tableViewMain.dequeueReusableCell(withIdentifier: "practiceCommentCell") as! practiceCommentCell
        
        comments.commentView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
       return comments
    }
     
   
}

