//
//  SystemColor.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/22/20.
//

import Foundation
import UIKit

/// Custom class to help defoine the color of the app. All the colors handled here.
class SystemColor {
    /// Makes all of the collectionview cells the same through out the system
    static func buildCollectionCell(cell: UICollectionViewCell) -> UICollectionViewCell {
        let customCell: UICollectionViewCell = cell
        
        customCell.layer.cornerRadius = 10
        customCell.backgroundColor = UIColor(red: 0xE7/255, green: 0xD3/255, blue: 0x13/255, alpha: 1.0)
        
        return customCell
    }
    
    /// Sets the background of the passed in UIView to the specified color
    static func setViewBG(view: UIView) {
        view.backgroundColor = UIColor(red: 0x94/255, green: 0xBD/255, blue: 0x7D/255, alpha: 1.0)
    }
    
    /// Sets the backgrou 
    static func setCollectionViwBG(for collection: UICollectionView) {
        collection.backgroundColor = UIColor(red: 0x94/255, green: 0xBD/255, blue: 0x7D/255, alpha: 1.0)
    }
    
    static func backgroundColor() -> UIColor {
        return UIColor(red: 0x94/255, green: 0xBD/255, blue: 0x7D/255, alpha: 1.0)
    }
}
