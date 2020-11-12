//
//  DayJob.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/16/20.
//

import Foundation

struct DayJob {
    
    private(set) var check: Int
    
    
    private(set) var fiftyPercent: Bool
    
    
    
    let money: Money = Money()
    
    init() {
        check = 0
        fiftyPercent = false
    }
    
    // MARK: - Setters
    public mutating func setCheck(newCheck: Int) {
        print(newCheck)
        guard newCheck > 0 else {
            check = 0
            return
        }
        
        check = newCheck
    }
    
    public mutating func setFifty(newFifty: Bool) {
        fiftyPercent = newFifty
    }
    
    public func calculateDayJob() -> String {
        var earnedGold: Double = Double(check)
        
        if check < 5 {
            earnedGold = 0.0
        } else if check < 10 {
            earnedGold = 1.0
        } else if check < 15 {
            earnedGold = 5.0
        } else if check < 20 {
            earnedGold = 10.0
        } else if check < 25 {
            earnedGold = 20.0
        } else if check < 30 {
            earnedGold = 50.0
        } else if check < 35 {
            earnedGold = 75.0
        } else if check < 40 {
            earnedGold = 100.0
        } else {
            earnedGold = 150.0
        }
        
        if fiftyPercent == true {
            earnedGold = earnedGold + (earnedGold * 0.50)
        }
//        return "Congratulations you earned \(money.separateMoney(newGold: earnedGold))"
        return "Congratulations you earned \(earnedGold)"
    }
}
