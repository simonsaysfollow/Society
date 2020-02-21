//
//  MainPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase


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
                        self.comment.append(GetComment(snapshot: obj as! DataSnapshot))
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
    
    //use this to update likes
   @objc func thisIsLiked(sender:UIButton) {
        
    firebaseRef.child("comments").child(sender.accessibilityLabel!).observeSingleEvent(of: .value) { (snapshot) in
                
            _ = Liked(snapshot: snapshot, key: sender.accessibilityLabel!) // add key to check if it is liked or not liked
            
                self.tableViewMain.reloadData()
            
        }
    }
    
    @objc func thisIsTrash(sender:UIButton) {
        
        firebaseRef.child("comments").child(sender.accessibilityLabel!).observeSingleEvent(of:.value) { (snapshot) in
        
            _ = Disliked(snapshot: snapshot, key: sender.accessibilityLabel!) // add key to check if it is liked or not liked
               self.tableViewMain.reloadData()
            
            
        }
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
            
//            let cell = tableViewMain.dequeueReusableCell(withIdentifier: "mainPost") as! PostsCell
//            cell.postUsernameLabel?.text = postComment?.createdByUsername == nil ? postPassed?.createdByUsername : postComment?.createdByUsername
//            cell.mainTextViewPost?.text = postComment?.theComment == nil ? postPassed?.thePost : postComment?.theComment
//            cell.replyToPost.addTarget(self, action: #selector(replyFromMainHeader), for: .touchDown)
//            return cell
            let cell = tableViewMain.dequeueReusableCell(withIdentifier: "postComment") as! PostComment
            cell.userLabel?.text = postComment?.createdByUsername == nil ? postPassed?.createdByUsername : postComment?.createdByUsername
            cell.postComment?.text = postComment?.theComment == nil ? postPassed?.thePost : postComment?.theComment
            cell.replyBtn.addTarget(self, action: #selector(replyFromMainHeader), for: .touchDown)
            cell.replyBtn?.isEnabled = (postComment?.theComment == nil ? postPassed!.allowComments : postComment!.allowComments)!
            
            cell.selectionStyle = .none
            return cell
        }
        
        let comments = tableViewMain.dequeueReusableCell(withIdentifier: "postComment") as! PostComment
        comments.userLabel?.text = comment[indexPath.row].createdByUsername ?? ""
        comments.postComment?.text = comment[indexPath.row].theComment ?? ""
        
        comments.replyBtn?.tag = indexPath.row
        comments.replyBtn?.addTarget(self, action: #selector(replyBtnSelected(sender: )), for: .touchDown)
        comments.replyBtn?.isEnabled = comment[indexPath.row].allowComments ?? true
        
        
        //good rating button
        comments.goodRating.accessibilityLabel = comment[indexPath.row].commentKey
        comments.goodRating.addTarget(self, action: #selector(thisIsLiked(sender:)), for: .touchDown)
        comments.goodRating.tintColor = comment[indexPath.row].usersthatliked == "liked" ? .red : .blue
        
        
        //bad rating button
        comments.badRating.accessibilityLabel = comment[indexPath.row].commentKey
        comments.badRating.addTarget(self, action: #selector(thisIsTrash(sender:)), for: .touchDown)
        comments.badRating.tintColor = comment[indexPath.row].usersthatliked == "disliked" ? .red : .blue
        
        comments.selectionStyle = .none
        return comments
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comments"
        }
        return "Home"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50 
        }
//        return 20
        return 0
    }
    

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
//        if section == 0 {
//            view.tintColor = .orange
//            let header = view as! UITableViewHeaderFooterView
//            header.textLabel?.textColor = UIColor.white
//            view.sendSubviewToBack(view)
//        }
        
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

