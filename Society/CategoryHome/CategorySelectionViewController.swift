//
//  CategorySelectionViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class CategorySelectionViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    
    //MARK: variables
    let topics = ["#MostLiked","#Sex","#Romantic","#Drugs","#FML", "#SocialInjustice","#Politics","#Feminism","#LGBTQ","#BlackLivesMatter", "#PartnerStories", "#MyDumbassBoyfriend", "#SocialInjustice","#Politics","#Feminism","#LGBTQ","#BlackLivesMatter", "#PartnerStories", "#MyDumbassBoyfriend"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        rightBarItem.image = UIImage(named: "peaceOut")!.withRenderingMode(.alwaysOriginal)
        
    }
    

}

extension CategorySelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count >= 16 ? 16 : topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCollection", for: indexPath) as! CollectionCell
        
        cell.topicLabel.text = topics[indexPath.row]
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.orange.cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(topics[indexPath.row])
        
        let topicH = topic.instantiateInitialViewController() as! UINavigationController
        topicH.navigationBar.topItem?.title = topics[indexPath.row]
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
