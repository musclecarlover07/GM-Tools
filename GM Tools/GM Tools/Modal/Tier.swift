//
//  Tier.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/14/20.
//

import Foundation

/// Tier type that helps determine the Tier the group is playing as well as help
/// determine the average party level.
enum Tier: Int {
    case noTier = 0, oneFive, threeSeven, fiveNine

    /// Description on the form of a String of each case. Useful for changing Tier to a String for display
    /// purposes.
    /// - returns: A represenstation of the Tier as a string
    func description() -> String {
        switch self {
        case .noTier:
            return "No Tier"
            
        case .oneFive:
            return "1-5"
            
        case .threeSeven:
            return "3-7"
            
        case .fiveNine:
            return "5-9"
        }
    }
    
    func tierOptions() -> [Int] {
        var lower: Int = 0
        var upper: Int = 0
        
        switch self {
        case .noTier:
            lower = 0
            upper = 0
            
        case .oneFive:
            lower = 1
            upper = 5
            
        case .threeSeven:
            lower = 3
            upper = 7
            
        case .fiveNine:
            lower = 5
            upper = 9
        }
        
        var options: [Int] = []
        let range: Range = Range(lower...upper)
        
        for value in range {
            options.append(value)
        }
        
        return options
    }
    
    func setSubTiers() -> Int {
        let tiers: [Int] = tierOptions()
        
        return (tiers.reduce(0, +)) / tiers.count
    }
    
    /// Builds a list with all of the cases in an array. Very useful for building a UIPickerView to select the
        /// Tier and set it. Determines the list based on thte actual Tier Type.
        /// Multiple lists can be created. Be termined by the Tier being seleted
        /// - returns: A list of all of the cases to be used in a UIPickerView
        
    func buildTiers() -> [Int] {
        switch self {
        case .noTier:
            return [0]
            
        case .oneFive:
            return [1, 2, 3, 4, 5]
            
        case .threeSeven:
            return [3, 4, 5, 6, 7]
            
        case .fiveNine:
            return [5, 6, 7, 8, 9]
        }
    }
    // MARK: - Static
    static func tierList() -> [String] {
        var i = 0
        var list: [String] = []
        
        while let tier = Tier(rawValue: i) {
            if tier.description() != "No Tier" {
                list.append(tier.description())
            }
            
            i += 1
        }
        
        return list
    }
    
    /// Converts a String into a Tier type. If the String does not match then it is assumed Nil
    /// is the option.
    /// - Parameter string: The string that tis being passed in to convert
    /// - returns: A Tier type. Helps control other elements in the app
    static func fromString(_ string: String) -> Tier {
        if string == "1-5" {
            return .oneFive
        } else if string == "3-7" {
            return .threeSeven
        } else if string == "5-9" {
            return .fiveNine
        } else {
            return .noTier
        }
    }
}


enum TierSecond: Int {
    case noTier = 0, oneFour, threeSix
    
    func description() -> String {
        switch self {
        case .noTier:
            return "No Tier"
            
        case .oneFour:
            return "1-4"
            
        case .threeSix:
            return "3-6"
        }
    }
    
    func minLevel() -> Int {
        switch self {
        case .noTier:
            return 0
            
        case .oneFour:
            return 1
            
        case .threeSix:
            return 3
        }
    }
    
    // MARK: - Static
    static func tierList() -> [String] {
        var i = 0
        var list: [String] = []
        
        while let tierSecond = TierSecond(rawValue: i) {
            if tierSecond.description() != "No Tier" {
                list.append(tierSecond.description())
            }
            
            i += 1
        }
        
        return list
    }
    
    /// Converts a String into a Tier type. If the String does not match then it is assumed Nil
    /// is the option.
    /// - Parameter string: The string that tis being passed in to convert
    /// - returns: A Tier type. Helps control other elements in the app
    static func fromString(_ string: String) -> TierSecond {
        if string == "1-4" {
            return .oneFour
        } else if string == "3-6" {
            return .threeSix
        } else {
            return .noTier
        }
    }
}
