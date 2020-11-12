//
//  MoneyCalc.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/20/20.
//

import Foundation

struct Money {
    func separateMoney(newGold: Double) -> String {
        let gold = newGold.truncatingRemainder(dividingBy: 100.0)
        let silver = newGold.truncatingRemainder(dividingBy: 1.0)
        let copper = newGold.truncatingRemainder(dividingBy: 0.1)
        
        // Converts to string and formats to have 2 floating points
        var goldString: String = String(format: "%.2f", gold)
        var silverString: String = String(format: "%.2f", silver)
        let copperString: String = String(format: "%.2f", copper)
        
        var moneyString: String = ""
        
        goldString.removeLast()
        goldString.removeLast()
        goldString.removeLast()
        
        silverString.removeLast()
        let newSilverString = silverString.last
        let newCopperString = copperString.last
        
        if goldString != "0" {
            moneyString = moneyString + goldString + " gold, "
        }

        if newSilverString != "0" {
            moneyString = moneyString + "\(String(describing: newSilverString!))" + " silver, "
        }
        
        if newCopperString != "0" {
            moneyString = moneyString + "\(String(describing: newCopperString!))" + " copper."
        }
        
        return moneyString
    }
}
