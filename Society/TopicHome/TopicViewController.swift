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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var topicPassed:String?
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var addPostBtn: UIBarButtonItem!
    
    var getTopicPosts = [GetTopicPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        createButtonAsTitle()
        
        getPostsByTopic(topic: removeHashTag(topic: topicPassed!))
        
        self.tableView.tableFooterView = UIView()
        
        if navigationItem.title == "#MostLiked" {
            addPostBtn.isEnabled = false
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
    
    func removeHashTag(topic:String) -> String {
        return topic.replacingOccurrences(of: "#", with: "")
    }
    
   @objc func reloadTableView() {
    //make sure to hit db first
        getTopicPosts.removeAll()
        getPostsByTopic(topic: removeHashTag(topic: topicPassed!))
        tableView.reloadData()
    }
    
    @IBAction func selectTypeOfFilter(_ sender: UIButton) {
        ReusableComponents().filteringOptions(viewController:self, tableView: tableView)
    }
    
    //calling from categorySelectionViewController - this calls db for post specific to topic
     func getPostsByTopic(topic:String) {
        firebaseRef.child("Society").child(topic).observe(.value, with: { (snapshot) in
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
    
 
}

extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getTopicPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as! PostsCell
        cell.postSettingsBtn.addTarget(self, action: #selector(postSettingsBtn), for: .touchDown)
        cell.thePosts?.text = getTopicPosts[indexPath.row].thePost
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainPost = topic.instantiateViewController(identifier: "theMainPost") as! MainPostViewController
        mainPost.postPassed = getTopicPosts[indexPath.row]
        present(mainPost,animated: true)
    }
    
    
}
