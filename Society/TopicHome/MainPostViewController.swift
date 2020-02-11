//
//  MainPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class MainPostViewController: UIViewController {

    @IBOutlet weak var tableViewMain: UITableView!
    
    var postPassed: GetTopicPost?
    var postComment: GetComment?
    var comment = [GetComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
        getComments()
    }
    
    @objc func filterCaller() {
        ReusableComponents().filteringOptions(viewController: self,tableView: tableViewMain)
    }
        
    fileprivate func getComments() {
        let passedObj = postPassed?.topicKey == nil ? postComment?.commentKey : postPassed?.topicKey
        firebaseRef.child("comments").observe(.value) { (snapshot) in
            if snapshot.exists() {
                if !self.comment.isEmpty {self.comment.removeAll()}
                for obj in snapshot.children.allObjects {
                    let snap = obj as? DataSnapshot
                    let snapObject = snap?.value as! NSDictionary
                    if snapObject["postyourrespondingtokey"] as? String == passedObj {
                        self.comment.append(GetComment(snapshot: obj as! DataSnapshot, passedObj: passedObj!))
                        self.tableViewMain.reloadData()
                    }
                }
            }
        }
    }
    
    @objc fileprivate func replyBtnSelected(sender:UIButton) {

        let mainPost = topic.instantiateViewController(identifier: "theMainPost") as! MainPostViewController
        
        mainPost.postComment =  postComment == nil ? comment[sender.tag] : postComment
        present(mainPost, animated: true) {
            
            let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
            addComment.topicPassed = "anything"
            addComment.postKey = self.comment[sender.tag].commentKey == nil ? self.postPassed?.topicKey : self.comment[sender.tag].commentKey
            mainPost.present(addComment, animated: true)
        }
    }
    
    
    //can be made resuable
  @objc fileprivate func replyFromMainHeader() {
        let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addComment.topicPassed = "anything"
        addComment.postKey = self.postComment?.commentKey == nil ? self.postPassed?.topicKey : self.postComment?.commentKey
        self.present(addComment, animated: true)
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
        return self.comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableViewMain.dequeueReusableCell(withIdentifier: "mainPost") as! PostsCell
            cell.postUsernameLabel?.text = postComment?.createdByUsername == nil ? postPassed?.createdByUsername : postComment?.createdByUsername
            cell.mainTextViewPost?.text = postComment?.theComment == nil ? postPassed?.thePost : postComment?.theComment
            cell.replyToPost.addTarget(self, action: #selector(replyFromMainHeader), for: .touchDown)
            return cell
        }
        
        let comments = tableViewMain.dequeueReusableCell(withIdentifier: "postComment") as! PostComment
        comments.userLabel?.text = comment[indexPath.row].createdByUsername ?? ""
        comments.postComment?.text = comment[indexPath.row].theComment ?? ""
        comments.replyBtn?.tag = indexPath.row
        comments.selectionStyle = .none
        comments.replyBtn?.addTarget(self, action: #selector(replyBtnSelected(sender: )), for: .touchDown)
        return comments
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comments"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50 
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section == 1 {
            view.tintColor = .orange
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
            
           let button = UIButton()
           button.tag = section
           button.setTitle("Filter", for: .normal)
           button.backgroundColor = .white
           button.addTarget(self, action: #selector(filterCaller), for: .touchDown)
           button.titleLabel?.font = UIFont(name:"UICTFontTextStyleHeadline" , size: 17)
           button.setTitleColor(.orange, for: .normal)
           view.addSubview(button)
            
           button.translatesAutoresizingMaskIntoConstraints = false
        
           button.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
           button.widthAnchor.constraint(equalToConstant: 70).isActive = true
           button.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10 ).isActive = true
           button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
 
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
           let mainPost = topic.instantiateViewController(identifier: "theMainPost") as! MainPostViewController
            mainPost.postComment = comment[indexPath.row]
           present(mainPost,animated: true)
        }
        
    }
     
   
}

