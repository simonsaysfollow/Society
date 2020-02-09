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
    
    
//    fileprivate func addComments() {
//        firebaseRef.child("Comments").child(postPassed!.key!).childByAutoId()
//
//    }
//
    fileprivate func getComments() {
        let passedObj = postPassed?.topicKey == nil ? postComment?.commentKey : postPassed?.topicKey
        let passedObjCount:Int = postPassed?.topicKey == nil ? postComment!.commentCount! : 3
        firebaseRef.child("comments").child(passedObj!).observe(.value) { (snapshot) in
            if snapshot.exists() {
                for num in 0..<snapshot.childrenCount {
                   let snap = snapshot.children.allObjects[Int(num)] as! DataSnapshot
                   let snapKey = snap.value! as? String
                    if snapKey != passedObj && snapKey != nil {
                        firebaseRef.child("comments").child(snapKey!).observe(.value) { (snapshot) in
                        self.comment.append(GetComment(snapshot: snapshot))
                        self.tableViewMain.reloadData()
                    }
                }
                }
            }
        }
    }
    
    @objc fileprivate func replyBtnSelected() {
        let addComment = topic.instantiateViewController(identifier: "addPostController") as! AddPostViewController
        addComment.topicPassed = "anything"
        addComment.postKey = postPassed?.topicKey
        present(addComment,animated: true)
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
            cell.mainTextViewPost?.text = postPassed?.thePost == nil ? postComment?.theComment : postPassed?.thePost
            cell.replyToPost.addTarget(self, action: #selector(replyBtnSelected), for: .touchDown)
            return cell
        }
        let comments = tableViewMain.dequeueReusableCell(withIdentifier: "postComment") as! PostComment
        if let commentText = comment[indexPath.row].theComment {
            comments.postComment.text = commentText
        }
        comments.replyBtn.addTarget(self, action: #selector(replyBtnSelected), for: .touchDown)

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

