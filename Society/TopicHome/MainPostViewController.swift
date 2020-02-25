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
        
        self.getComments()
        self.getPassedFromDB()
        
    }
    
    @objc func filterCaller() {
    
            let alert = UIAlertController(title: "", message: "How would you like to filter?", preferredStyle: .actionSheet)
            
            let liked = UIAlertAction(title: "Most Liked", style: .default) { (UIAlertAction) in
                self.getMostLiked()
            }
            
            let trash = UIAlertAction(title: "Most Trash", style: .default) {
                (UIAlertAction) in
                self.getMostTrash()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(liked)
            alert.addAction(trash)
            alert.addAction(cancel)
            
            present(alert, animated: true)
        
    }
    
    func getMostLiked() {
         //this needs to be configured to make the highest liked count show first -> set/dictionary returns unordered
        let passedObj = postPassed?.topicKey == nil ? postComment?.commentKey : postPassed?.topicKey
        firebaseRef.child("comments").queryOrdered(byChild: "likedcount").queryStarting(atValue: 5).queryLimited(toLast: 50).observe(.value) { (snapshot) in
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
    
    func getMostTrash() {
        //this needs to be configured to make the highest trash count show first -> set/dictionary returns unordered
        let passedObj = postPassed?.topicKey == nil ? postComment?.commentKey : postPassed?.topicKey
        firebaseRef.child("comments").queryOrdered(byChild: "trashcount").queryStarting(atValue: 5).queryLimited(toLast: 50).observe(.value) { (snapshot) in
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
    
    fileprivate func getPassedFromDB() {
       
        if postComment == nil {
            let topic = Resuable().removeHashTag(topic: postPassed!.topic!)
            firebaseRef.child("topicspost").child(topic).child(postPassed!.topicKey!).observe(.value) { (snapShot) in
                self.postPassed = GetTopicPost(snapshot: snapShot)
                self.tableViewMain.reloadData()
            }
        }else {
            firebaseRef.child("comments").child(postComment!.commentKey!).observe(.value) { (snapShot) in
                self.postComment = GetComment(snapshot: snapShot)
                self.tableViewMain.reloadData()
            }
        
        }

    }
    
    @objc fileprivate func replyBtnSelected(sender:UIButton) {
        let mainPost = topic.instantiateViewController(identifier: "theMainPost") as! MainPostViewController
        mainPost.postComment =  postComment == nil ? comment[sender.tag] : postComment
        present(mainPost, animated: true) {
            
            let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
            addComment.topicPassed = self.comment[sender.tag].topic == nil ? self.postPassed?.topic : self.comment[sender.tag].topic
            addComment.postKey = self.comment[sender.tag].commentKey == nil ? self.postPassed?.topicKey : self.comment[sender.tag].commentKey
            mainPost.present(addComment, animated: true)
        }
    }
    
    
    //can be made resuable
  @objc fileprivate func replyFromMainHeader() {
        let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addComment.topicPassed = self.postComment?.topic == nil ? self.postPassed?.topic : self.postComment?.topic
        addComment.postKey = self.postComment?.commentKey == nil ? self.postPassed?.topicKey : self.postComment?.commentKey
        self.present(addComment, animated: true)
    }
    
    //use this to update likes
   @objc func thisIsLiked(sender:UIButton) {
        
        firebaseRef.child("comments").child(sender.accessibilityLabel!).observeSingleEvent(of: .value) { (snapshot) in
            _ = Liked(snapshot: snapshot, key: sender.accessibilityLabel!, path: "comments") // add key to check if it is liked or not liked
                self.tableViewMain.reloadData()
            
        }
    }
    
    @objc func thisIsTrash(sender:UIButton) {
        
        firebaseRef.child("comments").child(sender.accessibilityLabel!).observeSingleEvent(of:.value) { (snapshot) in
            _ = Disliked(snapshot: snapshot, key: sender.accessibilityLabel!, path: "comments") // add key to check if it is liked or not liked
               self.tableViewMain.reloadData()
        }
    }
    
    @objc func headerIsLiked() {
    
        if postComment?.commentKey != nil {
            
            firebaseRef.child("comments").child(postComment!.commentKey!).observeSingleEvent(of: .value) { (snapshot) in
                _ = Liked(snapshot: snapshot, key: self.postComment!.commentKey! , path: "comments")
                self.getPassedFromDB()
                }
        }else {
            
            let noHashTopic = Resuable().removeHashTag(topic: postPassed!.topic!)
            firebaseRef.child("topicspost").child(noHashTopic).child(postPassed!.topicKey!).observeSingleEvent(of: .value) { (snapshot) in
            _ = Liked(snapshot: snapshot, key: self.postPassed!.topicKey! , path: "topicspost")
                self.getPassedFromDB()
                
                }
            }
           
       }
    
    @objc func headerIsTrash() {
        
        if postComment?.commentKey != nil {
            
            firebaseRef.child("comments").child(postComment!.commentKey!).observeSingleEvent(of:.value) { (snapshot) in
                _ = Disliked(snapshot: snapshot, key: self.postComment!.commentKey!, path: "comments")
                self.getPassedFromDB()
            }
        }else {
            
            let noHashTopic = Resuable().removeHashTag(topic:postPassed!.topic!)
            firebaseRef.child("topicspost").child(noHashTopic).child(postPassed!.topicKey!).observeSingleEvent(of: .value) { (snapshot) in
               _ = Disliked(snapshot: snapshot, key: self.postPassed!.topicKey! , path: "topicspost")
                self.getPassedFromDB()
  
            }
        }
    }
    
    @objc func flagging() {
        
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
            
            cell.replyBtn?.addTarget(self, action: #selector(self.replyFromMainHeader), for: .touchDown)
            cell.replyBtn?.isEnabled = (postComment?.theComment == nil ? postPassed!.allowComments : postComment!.allowComments)!
            
            cell.goodRating?.addTarget(self, action: #selector(headerIsLiked), for: .touchDown)
            cell.goodRating?.tintColor = postComment?.usersthatliked == nil ? postPassed?.usersthatliked == "liked" ? .red : .blue : postComment?.usersthatliked == "liked" ? .red : .blue
            
            cell.badRating?.addTarget(self, action: #selector(headerIsTrash), for: .touchDown)
            cell.badRating?.tintColor = postComment?.usersthatliked == nil ? postPassed?.usersthatliked == "disliked" ? .red : .blue : postComment?.usersthatliked == "disliked" ? .red : .blue
            
        
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
        return 0
    }
    

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let button = UIButton()
        
//        if section == 0 {
//           view.tintColor = .orange
//           let header1 = view as! UITableViewHeaderFooterView
//           header1.textLabel?.textColor = UIColor.white
//            view.sendSubviewToBack(button)
//        }
        
        if section == 1 {
            view.tintColor = .orange
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
        
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

