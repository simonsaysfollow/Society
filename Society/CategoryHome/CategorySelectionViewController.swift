//
//  CategorySelectionViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class CategorySelectionViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var bottomCollectionView: NSLayoutConstraint!
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    @IBOutlet weak var moreTopics: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: variables
    
    fileprivate var wantMore = false
    
    let topics = ["#MostLiked","#Sex","#Romantic","#Drugs","#FML", "#SocialInjustice","#Politics","#Feminism","#LGBTQ","#BlackLivesMatter", "#PartnerStories", "#MyDumbassBoyfriend", "#SocialInjustice","#Politics","#Feminism","#LGBTQ","#BlackLivesMatter", "#PartnerStories", "#MyDumbassBoyfriend"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
//         rightBarItem.image = UIImage(named: "peaceOut")!.withRenderingMode(.alwaysOriginal)
        searchBar.searchTextField .backgroundColor = .white
        moreTopics.isHidden = true
        bottomCollectionView.constant  = -86
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wantMore = false
        collectionView.reloadData()
    }
    
    
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if wantMore == false {

            if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //reach bottom
                moreTopics.isHidden = false
                bottomCollectionView.constant  = 0
            }

            if (scrollView.contentOffset.y <= 0){
                //reach top
                 moreTopics.isHidden = true
    //             bottomCollectionView.constant  = -86
            }

            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y+68 < (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //not top and not bottom
                moreTopics.isHidden = true
                bottomCollectionView.constant  = -86

            }
        }
    }
    
    
    @IBAction func addMoreTopics(_ sender: Any) {
        wantMore = true
        moreTopics.isHidden = true
        bottomCollectionView.constant  = -86
        collectionView.reloadData()
    }
    
    @objc func xyz() {
        TopicViewController().reloadTableView()
    }
    
    
}

extension CategorySelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wantMore == false ? 16 : topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCollection", for: indexPath) as! CollectionCell
        cell.topicLabel.text = topics[indexPath.row]
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.orange.cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let topicH = topic.instantiateInitialViewController() as! UINavigationController
        let rootViewController = topicH.viewControllers.first as! TopicViewController
        rootViewController.topicPassed = topics[indexPath.row]
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
