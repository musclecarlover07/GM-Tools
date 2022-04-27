//
//  MenuTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/10/20.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var pathfinder1Menu: UICollectionView!
    @IBOutlet weak var pathfinder2Menu: UICollectionView!
    
    let pathfinder1: [String] = ["Average Party Level", "Day Job"]
    let pathfinder2: [String] = ["Challenge Points", "Earn Income"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        // Set background color
        self.navigationController?.navigationBar.barTintColor = SystemColor.backgroundColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        SystemColor.setViewBG(view: self.view)
        SystemColor.setCollectionViwBG(for: pathfinder1Menu)
        SystemColor.setCollectionViwBG(for: pathfinder2Menu)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 0x96/255, green: 0xBc/255, blue: 0x7E/255, alpha: 1.0)
    }
}

extension MenuTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pathfinder1Menu {
            return pathfinder1.count
        } else if collectionView == pathfinder2Menu {
            return pathfinder1.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        
        cell.menuItem.textColor = .black
        
        if collectionView == pathfinder1Menu {
            cell.menuItem.text = pathfinder1[indexPath.row]
            
            return SystemColor.buildCollectionCell(cell: cell)
        } else if collectionView == pathfinder2Menu {
            cell.menuItem.text = pathfinder2[indexPath.row]
            
            return SystemColor.buildCollectionCell(cell: cell)
        } else {
            cell.menuItem.text = "No Item"
            
            return SystemColor.buildCollectionCell(cell: cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == pathfinder1Menu {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "apl", sender: nil)
            } else {
                performSegue(withIdentifier: "dayJob", sender: nil)
            }
        } else if collectionView == pathfinder2Menu {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "challengePoints", sender: nil)
            } else {
                performSegue(withIdentifier: "earnIncome", sender: nil)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
}
