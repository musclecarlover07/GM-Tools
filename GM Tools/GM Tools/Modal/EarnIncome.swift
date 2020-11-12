//
//  EarnIncome.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/7/20.
//

import Foundation

/// Struct to hold all information regarding Earn Income
struct EarnIncome {
    // Basic Building Blocks
    
    // charLevel the level of the character that needs to Earn Income. Task level
    // is based off the character. Normaly it charLevel - 2 (min 0).
    private(set) var charLevel: Int
    
    // Proficiency level needed to deteremine how much money is calculated. This
    // is based off the taskLevel.
    private(set) var proficiency: Proficiency
    
    // numOfDays the number of days the character will get to Earn Income. Every
    // 8 days will need an additional check. Example Micheal will earn 12 days
    // of down time to Earn Income. So he will have 2 chacks, 1 check for 8 days
    // and 1 check for 4 days.
    private(set) var numOfDays: Int
    
    // taskMod the modifier to adjust the taskLevel. Normally the taskMod will adjust
    // the taskLevel to be closer to the charLevel.
    private(set) var taskMod: Int
    
    // numOfChecks the number of checks the character makes. All checks are set
    // to zero when created or added. Every 8 days grants an additional check.
    private(set) var numOfChecks: [Int]
    
    // Computed Properties
    
    // This is the task modifier. This will determine what the result will be.
    // Normally the task modifer is charLevel - 2 (min 0). Some feats or boons
    // may modify the task level. Typically a task mod will lover the modifier
    // ultimately bring the taskLevel to equal the character level.
    private var taskLevel: Int {
        get {
            // If charLevel is less than 2 sets taskLevel to 0. Else charLevel - 2
            if charLevel + taskMod < 2 {
                return 0
            } else {
                return charLevel - 2 + taskMod
            }
        }
    }
    
    /// An array with the number of days split into increments of 8 days. Each element will correspond with
    /// a check.
    public var daysArray: [Int] {
        get {
            var tempArray: [Int] = []
            var tempDayCount: Int = numOfDays
            var count: Int = 0
                        
            for _ in numOfChecks {
                tempArray.append(0)
            }
            
            repeat {
                // Check to see if numOfDays >= 8
                if tempDayCount > 8 {
                    tempArray[count] = 8
                    tempDayCount -= 8
                } else {
                    tempArray[count] = tempDayCount
                    tempDayCount -= tempDayCount
                }
                
                count += 1
            } while tempDayCount > 0             //count + 1 < numOfDays
            
            return tempArray
        }
    }
    
    public var checkResults: [Double] {
        get {
            var tempArray: [Double] = []
            var count: Int = 0
            
            for i in numOfChecks {
                print("i:", i)
                tempArray.append(calculateIncome(at: count))
                count += 1
            }
            
            return tempArray
        }
    }
    
    /// The dc of the check. This is based on the taskLevel. This will help determined if the failure array will
    /// need to be used. It will also determine if the taskLevel is modified at all.
    private var dc: [Int] = [14, 15, 16, 18, 19, 20, 22, 23, 24, 26, 27, 28, 30, 31, 32, 34, 35, 36, 38, 39, 40]
    
    init() {
        charLevel = 1
        proficiency = .notTrained
        numOfDays = 1
        taskMod = 0
        numOfChecks = [0]
    }
    
    // MARK: - Setter
    
    /// Sets the charLevel
    /// charLevel must be greater than 0 and less than 20
    /// - Parameter newLevel: The new level of the character.
    public mutating func setCharLevel(newLevel: Int) {
        guard newLevel > 0 && newLevel < 21 else {
            charLevel = 1
            return
        }
        
        charLevel = newLevel
    }
    
    /// Sets the proficiency
    /// - Parameter newProficiency: A string, typically from a UITextfield, then to be converted to
    /// the Proficiency.
    public mutating func setProficiency(newProficiency: String) {
        proficiency = Proficiency.fromString(newProficiency)
    }
    
    /// Sets the number of days the character can Earn Income for. Also updates the *checks array with the
    /// correct number of checks needed.
    /// - Parameter addDays: The number of days the character gets for their down time of Earn Income.
    public mutating func setNumOfDays(addDays: Int) {
        // Sets the numOfDays
        if addDays < 0 {
            numOfDays = 1
        } else {
            numOfDays = addDays
        }
        
        // Updates the numOfChecks
        // Number of Checks that will need to be made
        var tempDays: Double {
            get {
                return ceil(Double(numOfDays) / 8.0)
            }
        }
        
        // If numOfChecks > tempDays
        // else
        if numOfChecks.count < Int(tempDays) {
            while numOfChecks.count < Int(tempDays) {
                numOfChecks.append(0)
            }
        } else if numOfChecks.count > Int(tempDays) {
            while numOfChecks.count > Int(tempDays) {
                numOfChecks.removeLast()
            }
        }
    }
    
    public mutating func setTaskMod(newTaskMod: Int) {
        guard newTaskMod > 0 else {
            taskMod = 0
            return
        }
    }
    
    private mutating func setChecks() {
        
    }
    
    // MARK: - Other
    // Update name

    /// Updates the numOfChecks array with the check.
    /// - Parameter check: The check the character got for that set of day.
    /// - Parameter index: The index of the UICollectionViewCell to update with the check.
    public mutating func updateCheck(with check: Int, at index: Int) {
        print("check: \(check), index: \(index)")
        numOfChecks[index] = check
    }
    
    func separateMoney(newGold: Double) -> String {
        let gold = newGold.truncatingRemainder(dividingBy: 100.0)
        let silver = newGold.truncatingRemainder(dividingBy: 1.0)
        let copper = newGold.truncatingRemainder(dividingBy: 0.1)
        
        // Converts to string and formats to have 2 floating points
        var goldString: String = String(format: "%.2f", gold)
        var silverString: String = String(format: "%.2f", silver)
        let copperString: String = String(format: "%.2f", copper)
        
//        let resultStr: String = String(format: "%.2f", earnIncome.checkResults[indexPath.row])
        
//        var moneyString: String = "\(newGold) You earned "
        
//        var moneyString: String = String(format: "%.2f", newGold)
        var moneyString: String = ""
        
        goldString.removeLast()
        goldString.removeLast()
        goldString.removeLast()
        
        silverString.removeLast()
        let newSilverString = silverString.last
        let newCopperString = copperString.last
        
    //    print("  Gold String:", goldString)
    //    print("Silver String:", newSilverString)
    //    print("Copper String:", newCopperString)
        
        if goldString != "0" {
            moneyString = moneyString + goldString + " gold, "
        }

        if newSilverString != "0" {
            moneyString = moneyString + "\(String(describing: newSilverString!))" + " silver, "
        }
        
        if newCopperString != "0" {
            moneyString = moneyString + "\(String(describing: newCopperString!))" + " copper."
        }
        
        print(moneyString)
        
    //    print("\(newGold) You earned \(goldString) gold, \(newSilverString ?? "a") silver, \(newCopperString ?? "a") copper")
        
    //    print("Gold: \(gold)")
    //    print("Silver: \(silver)")
    //    print("Copper: \(copper)")
        
        return moneyString
    }
    
    // MARK: - Calculations
    
    /// Calcualtes the income at a specific index
    /// - Parameter index:
    /// - returns:
    public func calculateIncome(at index: Int) -> Double {
        var dailyIncome: Double = 0.0
        // determines the daily income based on proficiency and the check
        // if -> critical success
        // else -> success
        // else -> critical failure
        // else -> failure
        print("earnIncome pre if index: ", index)
        
        print("Calculate tasklevel: ", taskLevel)
        
        if numOfChecks[index] >= dc[taskMod] + 10 {
            // taskLevel + 1
            dailyIncome = proficiency.calculateIncome()[taskLevel + 1]
        } else if numOfChecks[index] >= dc[taskMod] {
            // proficiency level
            dailyIncome = proficiency.calculateIncome()[taskLevel]
        } else if numOfChecks[index] < dc[taskMod] - 10 {
            // No gold
            return 0.0
        } else if numOfChecks[index] < dc[taskMod] {
            // failiure list
            dailyIncome = Proficiency.failureList()[taskLevel]
        } else {
            return 0.0
        }

        // the final income for the check
        return dailyIncome * Double(daysArray[index])
    }
    
    /// Calculates all the income for all of the checks. Used when determining the total amount the character
    /// earns.
    /// - Parameter index:
    /// - returns:
    public func calculateTotalIncome(with checks: [Int]) -> Double {
        var totalIncome: Double = 0.0
        var count: Int = 0
        
        for _ in numOfChecks {
            totalIncome += calculateIncome(at: count)
            count += 1
        }
        
        return totalIncome
    }
    
    public func calculateIncomeTest() {
        
        
        
        
    }
    
    // End of Struct -----------------------------------------------------------
}
