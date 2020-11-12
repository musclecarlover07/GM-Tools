//
//  Season.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/14/20.
//

import Foundation

enum Season: Int {
    case noSeason = 0, zeroThree, fourPlus
    
    /// Description on the form of a String of each case. Useful for changing Season to a String for display
    /// purposes.
    /// - returns: A represenstation of the Season as a string
    func description() -> String {
        switch self {
        case .noSeason:
            return "No Season"
            
        case .zeroThree:
            return "0-3"
            
        case .fourPlus:
            return "4+"
        }
    }
    
    // MARK: - Static
    /// Converts a String into a Season type. If the String does not match then it is assumed No Season
    /// is the option.
    /// - Parameter string: The string that tis being passed in to convert
    /// - returns: A Season type. Helps control other elements in the app
    static func fromString(_ string: String) -> Season {
        if string == "No Season" {
            return .noSeason
        } else if string == "0-3" {
            return .zeroThree
        } else if string == "4+" {
            return .fourPlus
        } else {
            return .noSeason
        }
    }
    
    /// Builds a list with all of the cases in an array. Very useful for building a UIPickerView to select the
    /// Season and set it.
    /// - returns: A list of all of the cases to be used in a UIPickerView
    static func seasonList() -> [String] {
        var i = 0
        var list: [String] = []
        
        while let season = Season(rawValue: i) {
            if season.description() != "No Season" {
                list.append(season.description())
            }
            
            i += 1
        }
        
        return list
    }
}
