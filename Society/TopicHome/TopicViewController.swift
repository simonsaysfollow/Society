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
    
    var topicPassed:String?
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var addPostBtn: UIBarButtonItem!
    
    var getTopicPosts = [GetTopicPost]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        createButtonAsTitle()
        self.tableView.tableFooterView = UIView()
    
        if topicPassed == "#MostLiked" {
            addPostBtn.isEnabled = false
            getPostsByTopic(topic: Resuable().removeHashTag(topic: topicPassed!))
        }else {
            getPostsByTopic(topic: Resuable().removeHashTag(topic: topicPassed!))
        }
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
        ReusableComponents().filteringOptions(viewController:self, tableView: tableView)
    }
    
    //calling from categorySelectionViewController - this calls db for post specific to topic
     func getPostsByTopic(topic:String) {
        firebaseRef.child("Society").child(topic).observe(.value, with: { (snapshot) in
            if !self.getTopicPosts.isEmpty {self.getTopicPosts.removeAll()}
            let snapshot = snapshot.children.allObjects as! [DataSnapshot]
            for x in snapshot {
                self.getTopicPosts.append(GetTopicPost(snapshot: x))
                self.tableView.reloadData()
                
            }
        })
    }
    
   
    @objc func postSettingsBtn() {
        
        let alert = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
              
        let share = UIAlertAction(title: "Share", style: .default) { (UIAlertAction) in
                  print("This post will be share")
              }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let flagged = UIAlertAction(title: "Flag", style: .default) { (UIAlertAction) in
                         print("This post will be flagged")
        }
        
        let delete = UIAlertAction(title: "Delete", style: .default) { (UIAlertAction) in
                         print("This post will be delete")
        }
        
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
       let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addComment.topicPassed = topicPassed
        present(addComment,animated: true)
    }
    
    
    @objc fileprivate func replyFromMainHeader(sender:UIButton) {
        let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addComment.topicPassed = "anything"
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
        cell.postUsernameLabel.text = getTopicPosts[indexPath.row].createdByUsername
        cell.postSettingsBtn.addTarget(self, action: #selector(postSettingsBtn), for: .touchDown)
        cell.thePosts?.text = getTopicPosts[indexPath.row].thePost
        cell.replyToPost?.addTarget(self, action: #selector(replyFromMainHeader(sender: )), for: .touchDown)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainPost = topic.instantiateViewController(identifier: "theMainPost") as! MainPostViewController
        mainPost.postPassed = getTopicPosts[indexPath.row]
        present(mainPost,animated: true)
    }
    
    
}
