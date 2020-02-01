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
    @IBOutlet weak var addPostBtn: UIBarButtonItem!
    
    var getTopicPosts = [GetTopicPost]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
             return .darkContent
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        createButtonAsTitle()
        
        getPostsByTopic(topic: removeHashTag(topic: topicPassed!))
        
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
                let obj = x.value as! NSDictionary
                self.getTopicPosts.append(GetTopicPost(snapshot: obj))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addingPostToTopic" {
            let addPost:AddPostViewController = segue.destination as! AddPostViewController
            addPost.topicPassed = topicPassed
        }
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
        print("selected")
        
        let mainPost = topic.instantiateViewController(identifier: "theMainPost")
        present(mainPost,animated: true)
    }
    
}
