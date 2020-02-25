//
//  TopicViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/18/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class TopicViewController: UIViewController {
    
    public var topicPassed:String?
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var addPostBtn: UIBarButtonItem!
    
    fileprivate var getTopicPosts = [GetTopicPost]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        createButtonAsTitle()
        self.tableView.tableFooterView = UIView()
        
        if topicPassed == "#MostLiked" || topicPassed == "#All" {
            addPostBtn.isEnabled = false
        }
        
        self.topicPassed = Resuable().removeHashTag(topic: topicPassed!)
        
        getPostsByTopic(topic: Resuable().removeHashTag(topic: topicPassed!))
    }
    
    
    fileprivate func createButtonAsTitle() {
        let button = UIButton()
        button.setTitle(topicPassed!, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.addTarget(self, action: #selector(reloadTableView), for: .touchDown)
        navigationItem.titleView = button
    }
    
    
    @objc func reloadTableView() {
        getTopicPosts.removeAll()
        getPostsByTopic(topic: Resuable().removeHashTag(topic: topicPassed!))
        tableView.reloadData()
    }
    
    @IBAction func selectTypeOfFilter(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "How would you like to filter?", preferredStyle: .actionSheet)
        
        let liked = UIAlertAction(title: "Most Liked", style: .default) { (UIAlertAction) in
            self.getTopicPosts.removeAll()
            self.getMostLiked()
            
        }
        
        let trash = UIAlertAction(title: "Most Trash", style: .default) {
            (UIAlertAction) in
            self.getTopicPosts.removeAll()
            self.getMostTrash()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(liked)
        alert.addAction(trash)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
    
    //calling from categorySelectionViewController - this calls db for post specific to topic
    func getPostsByTopic(topic:String) {
        
        if topic == "All" {
            // needs to be fixed so we can automatically update
            firebaseRef.child("topicspost").observeSingleEvent(of:.value) { (snapshot) in
                if !self.getTopicPosts.isEmpty {self.getTopicPosts.removeAll()}
                print("\(self.getTopicPosts.count) this is the value of gettopics count")
                let snap = snapshot.value as? NSDictionary
                for topics in snap!.allKeys {
                    let topics =  topics as? String
                    firebaseRef.child("topicspost").child(topics!).queryLimited(toLast: 50).observeSingleEvent(of:.value) { (snaps) in
                        let snapshot = snaps.children.allObjects as! [DataSnapshot]
                        for obj in snapshot {
                            self.getTopicPosts.append(GetTopicPost(snapshot: obj))
                            self.getTopicPosts = self.getTopicPosts.shuffled()
                            self.tableView.reloadData()

                        }
                    }
                }
            }
        }
        
        
        if topic == "MostLiked" {
            // needs to be fixed so we can automatically update
            firebaseRef.child("topicspost").observeSingleEvent(of:.value) { (snapshot) in
                if !self.getTopicPosts.isEmpty {self.getTopicPosts.removeAll()}
                let snap = snapshot.value as? NSDictionary
                for topics in snap!.allKeys {
                    let topics =  topics as? String
                    firebaseRef.child("topicspost").child(topics!).queryOrdered(byChild: "likedcount").queryStarting(atValue: 5, childKey: "likedcount").queryLimited(toLast: 50).observeSingleEvent(of: .value) { (snaps) in
                        let snapshot = snaps.children.allObjects as! [DataSnapshot]
                        for obj in snapshot {
                            self.getTopicPosts.append(GetTopicPost(snapshot: obj))
                            self.getTopicPosts = self.getTopicPosts.shuffled()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        if topic != "MostLiked" || topic != "All" {
            firebaseRef.child("topicspost").child(topic).observe(.value, with: { (snapshot) in
                if !self.getTopicPosts.isEmpty {self.getTopicPosts.removeAll()}
                let snapshot = snapshot.children.allObjects as! [DataSnapshot]
                for obj in snapshot {
                    self.getTopicPosts.append(GetTopicPost(snapshot: obj))
                    self.tableView.reloadData()
                    
                }
            })
        }
    }
    
    func getMostTrash() {
        let topic = Resuable().removeHashTag(topic: topicPassed!)
        firebaseRef.child("topicspost").child(topic).queryOrdered(byChild: "trashcount").queryStarting(atValue: 5, childKey: "trashcount").queryLimited(toLast: 50).observeSingleEvent(of: .value) { (snaps) in
            let snapshot = snaps.children.allObjects as! [DataSnapshot]
            for obj in snapshot {
                self.getTopicPosts.append(GetTopicPost(snapshot: obj))
                self.getTopicPosts = self.getTopicPosts.shuffled()
                self.tableView.reloadData()
            }
        }
    }
    
    func getMostLiked() {
        let topic = Resuable().removeHashTag(topic: topicPassed!)
        firebaseRef.child("topicspost").child(topic).queryOrdered(byChild: "likedcount").queryStarting(atValue: 5, childKey: "likedcount").queryLimited(toLast: 50).observeSingleEvent(of: .value) { (snaps) in
            let snapshot = snaps.children.allObjects as! [DataSnapshot]
            for obj in snapshot {
                self.getTopicPosts.append(GetTopicPost(snapshot: obj))
                self.getTopicPosts = self.getTopicPosts.shuffled()
                self.tableView.reloadData()
            }
        }
    }
    

    @objc func postSettingsBtn(sender:UIButton) {
        
        let flaggedOrUnFlagged:String = getTopicPosts[sender.tag].flagged! ? "Unflag" : "Flag"

        let alert = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)

        let share = UIAlertAction(title: "Share", style: .default) { (UIAlertAction) in
            print("This post will be share")
        }
        
        let flagged = UIAlertAction(title: flaggedOrUnFlagged , style: .default) { (UIAlertAction) in
            firebaseRef.child("topicspost").child(self.topicPassed!).child(self.getTopicPosts[sender.tag].topicKey!).observeSingleEvent(of: .value) { (snap) in
                let snapshotValue = snap.value as? NSDictionary
                let objectUserID = snapshotValue?["whoflagged"] as? NSDictionary
                let currentUserStatus =  objectUserID?[currentUserID as Any] as? Bool
                
                if currentUserStatus == false || currentUserStatus == nil {
                    firebaseRef.child("topicspost").child(self.topicPassed!).child(self.getTopicPosts[sender.tag].topicKey!).updateChildValues(["whoflagged":[currentUserID:true]])
                }else {
                    firebaseRef.child("topicspost").child(self.topicPassed!).child(self.getTopicPosts[sender.tag].topicKey!).updateChildValues(["whoflagged":[currentUserID:false]])
                }
            }
        }

        let delete = UIAlertAction(title: "Delete", style: .default) { (UIAlertAction) in
            print("This post will be delete")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(share)
        alert.addAction(flagged)
        alert.addAction(delete)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func addPostBtn(_ sender: Any) {
        let addPost = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addPost.topicPassedFromCategory = topicPassed
        present(addPost,animated: true)
    }
    
    
    @objc fileprivate func replyFromMainHeader(sender:UIButton) {
        let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addComment.topicPassed = getTopicPosts[sender.tag].topic
        addComment.postKey = getTopicPosts[sender.tag].topicKey
        self.present(addComment, animated: true)
    }
    
    
}

extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getTopicPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as! PostsCell
        
        if self.getTopicPosts.count != 0 {
            
        cell.postUsernameLabel?.text = getTopicPosts[indexPath.row].createdByUsername
            
        cell.postSettingsBtn.tag = indexPath.row
            cell.postSettingsBtn?.addTarget(self, action: #selector(postSettingsBtn(sender:)), for: .touchDown)
            
        cell.thePosts?.text = getTopicPosts[indexPath.row].thePost
        cell.replyToPost?.tag = indexPath.row
        cell.replyToPost?.addTarget(self, action: #selector(replyFromMainHeader(sender: )), for: .touchDown)
        
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainPost = topic.instantiateViewController(identifier: "theMainPost") as! MainPostViewController
        mainPost.postPassed = getTopicPosts[indexPath.row]
        present(mainPost,animated: true)
        
    }
    
    
}
