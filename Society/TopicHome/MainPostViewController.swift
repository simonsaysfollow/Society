//
//  MainPostViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/20/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class MainPostViewController: UIViewController {

    @IBOutlet weak var tableViewMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
    }
    


}

extension MainPostViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
       
        if indexPath.section == 0 && indexPath.row == 0 {
        let cell = tableViewMain.dequeueReusableCell(withIdentifier: "mainPost") as! PostsCell
        return cell
        }
        return cell
    }
    
    
}
