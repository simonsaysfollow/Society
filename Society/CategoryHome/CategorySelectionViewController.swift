//
//  CategorySelectionViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class CategorySelectionViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate {
    @IBOutlet weak fileprivate var bottomCollectionView: NSLayoutConstraint!
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var rightBarItem: UIBarButtonItem!
    @IBOutlet weak fileprivate var moreTopics: UIButton!
    @IBOutlet weak fileprivate var searchBar: UISearchBar!
    
    @IBOutlet weak var showAllBtn: UIButton!
    @IBOutlet weak var mostLikedBtn: UIButton!
    
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    
    
    //MARK: variables
    fileprivate var wantMore = false
    fileprivate var topicData = [DataTopicModel]()
    var newArray = [DataTopicModel]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calls DB as soon is page is init
        getTopicsFromDB()
        
        //Hides keyboard when view is tapped
        self.setupToHideKeyboardOnTapOnView()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //search bar setup
        searchBar.searchTextField .backgroundColor = .white
        searchBar.searchTextField.textColor = .orange
        searchBar.delegate = self
        
        //used to hide more options button
        moreTopics.isHidden = true
        bottomCollectionView.constant  = -86
        
        //set up most liked button
        mostLikedSetup()
    }
    
    func mostLikedSetup() {
        
        mostLikedBtn.layer.borderColor = UIColor.orange.cgColor
        mostLikedBtn.layer.borderWidth = 1
        mostLikedBtn.layer.cornerRadius = 3
        mostLikedBtn.clipsToBounds = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if wantMore == true {
            wantMore = false
            collectionView.reloadData()
        }
    }
    
    // check to see where the scroll controller is and addeds button for more buttons only at the bottom
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if wantMore == false {

            if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //reach bottom
                moreTopics.isHidden = false
                bottomCollectionView.constant  = 0
            }

            if (scrollView.contentOffset.y <= 0) {
                //reach top
                 moreTopics.isHidden = true
            }

            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y+68 < (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //not top and not bottom
                moreTopics.isHidden = true
                bottomCollectionView.constant  = -86

            }
        }
    }
    //   Gets all the topics from the DB and consistently observes for new added topics
     func getTopicsFromDB() {
        
        firebaseRef.child("topics").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                if !self.topicData.isEmpty {self.topicData.removeAll()}
                let snapshot = snapshot.value as! NSDictionary
                for keys in snapshot.allKeys {
                    let values = snapshot.value(forKey: keys as! String) as? NSDictionary
                    self.topicData.append(DataTopicModel(snapshot: values!)!)
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    
    @IBAction func addMoreTopics(_ sender: Any) {
        wantMore = true
        moreTopics.isHidden = true
        bottomCollectionView.constant  = -86
        collectionView.reloadData()
    }
    
    
    @IBAction func grabPostFromAllTopics(_ sender: Any) {
        passDataToTopicView(dataIndexPath: nil, dataString: "#MostLiked")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        self.topicData.removeAll()
        var text = searchBar.text
        if (text?.contains("#"))! {text?.removeFirst(0)}
        firebaseRef.child("topics").queryOrdered(byChild: "topiclabel").queryStarting(atValue: "#\(String(text!).capitalized)").observe(.value) { (Data) in
            for x in Data.children.allObjects {
                let obj = x as! DataSnapshot
                if (obj.key).contains(String(searchBar.text!)) {
                    self.topicData.append(DataTopicModel(snapshot: obj.value as! NSDictionary)!)
                   self.collectionView.reloadData()
                 }
                
            }
        }
        
        if searchBar.text!.count < 1 { 
           self.topicData = self.newArray
           self.collectionView.reloadData()
       }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarTrailing.constant = -15
        self.showAllBtn.setTitle("", for: .normal)
        self.newArray = self.topicData
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text!.count == 0 {
            self.topicData = self.newArray
            
        }
        DispatchQueue.main.async {
            self.searchBarTrailing.constant = -74
            self.showAllBtn.setTitle("All", for: .normal)
            self.collectionView.reloadData()
        }
       
    }
    
}

extension CategorySelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wantMore == false ? (self.topicData.count >= 12 ? 12 : self.topicData.count) : self.topicData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCollection", for: indexPath) as! CollectionCell
        
        cell.topicLabel.text = topicData[indexPath.row].topicLabel
        cell.topicLabel.textColor = .orange
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.orange.cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passDataToTopicView(dataIndexPath: indexPath.row, dataString: "")
    }
    
    fileprivate func passDataToTopicView(dataIndexPath:Int?, dataString:String) {
        let  dataToBePassed = dataString.isEmpty ? topicData[dataIndexPath!].topicLabel! : dataString
        let topicH = topic.instantiateInitialViewController() as! UINavigationController
        let rootViewController = topicH.viewControllers.first as! TopicViewController
        rootViewController.topicPassed = dataToBePassed
        topicH.modalPresentationStyle = .fullScreen
        self.present(topicH,animated: true)
    }
    
}

extension CategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
           layout collectionViewLayout: UICollectionViewLayout,
           sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 125)
    }
    
    
}
