//
//  Proficiency.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/7/20.
//

import Foundation

enum Proficiency: Int {
    case notTrained = 0, trained, expert, master, legendary
    
    /// Description on the form of a String of each case. Useful for changing Proficiency to a String for display
    /// purposes.
    /// - returns: A represenstation of the Proficiency as a string
    func description() -> String {
        switch self {
        case .notTrained:
            return "Not Trained"
            
        case .trained:
            return "Trained"
            
        case .expert:
            return "Expert"
            
        case .master:
            return "Master"
            
        case .legendary:
            return "Legendary"
        }
    }
    
    /// Based on ittself will help deteremien what the result of the Earn Income Check (per day) will be. It is
    /// and array of doubles. You deteremine which value ultimately by the taskLevel. That will be the accessor
    /// into the array. Then that result will be multiplied by the number of days to get that checks result. If there
    /// are multiple days, then all of these days will need to be added. These results are based on if the result
    /// is a success or better.
    func calculateIncome() -> [Double] {
        switch self {
        case .notTrained:
            return [0.0]
            
        case .trained:
            return [0.05, 0.2, 0.3, 0.5, 0.7, 0.9, 1.5, 2, 2.5, 3, 4, 5, 6, 7, 8, 10, 13, 15, 20, 30, 40, 50]
            
        case .expert:
            return [0.05, 0.2, 0.3, 0.5, 0.8, 1, 2, 2.5, 3, 4, 5, 6, 8, 10, 15, 20, 25, 30, 45, 60, 75, 90]
            
        case .master:
            return [0.05, 0.2, 0.3, 0.5, 0.8, 1, 2, 2.5, 3, 4, 6, 8, 10, 15, 20, 28, 36, 45, 70, 100, 150,175]
            
        case .legendary:
            return [0.05, 0.2, 0.3, 0.5, 0.8, 1, 2, 2.5, 3, 4, 6, 8, 10, 15, 20, 28, 40, 55, 90, 130, 200, 300]
        }
    }
    
    
    // MARK: - Static
    
    /// Converts a String into a Proiciency type. If the String does not match then it is assumed Not Trained
    /// is the option.
    /// - Parameter string: The string that tis being passed in to convert
    /// - returns: A Proficiency type. Helps control other elements in the app
    static func fromString(_ string: String) -> Proficiency {
        if string == "Trained" {
            return .trained
        } else if string == "Expert" {
            return .expert
        } else if string == "Master" {
            return .master
        } else if string == "Legendary" {
            return .legendary
        } else {
            return .notTrained
        }
    }
    
    /// Builds a list with all of the cases in an array. Very useful for building a UIPickerView to select the
    /// Proficiency and set it.
    /// - returns: A list of all of the cases to be used in a UIPickerView
    static func buildList() -> [String] {
        var i = 0
        var list: [String] = [String]()
        
        while let proficiency = Proficiency(rawValue: i) {
            list.append(proficiency.description())
            i = i + 1
        }
        
        return list
    }
    
    static func failureList() -> [Double] {
        return [0.01, 0.02, 0.04, 0.08, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.5, 2, 2.5, 3, 4, 6, 8]
    }
}
