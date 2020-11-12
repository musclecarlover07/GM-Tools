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
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .yellow
        
        if collectionView == pathfinder1Menu {
            cell.menuItem.text = pathfinder1[indexPath.row]
            
            return cell
        } else if collectionView == pathfinder2Menu {
            cell.menuItem.text = pathfinder2[indexPath.row]
            
            return cell
        } else {
            cell.menuItem.text = "No Item"
            
            return cell
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
