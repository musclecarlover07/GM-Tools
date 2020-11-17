//
//  Challenge.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/11/20.
//

import Foundation

struct Challenge {
    private(set) var tier: TierSecond
    private(set) var playerLevels: [Int]
    private(set) var playerChallenge: [Int]
    private(set) var highTier: Bool
    
    fileprivate(set) var cpAdj: Int
    
    private var totalCP: Int {
        get {
            return playerChallenge.reduce(0, +) + cpAdj
        }
        
    }
    
    private var willPlay: String {
        get {
            if highTier == true {
                return "Play High Tier"
            } else {
                return "Play Low Tier"
            }
        }
    }
    
    init() {
        tier = .noTier
        playerLevels = [0, 0]
        playerChallenge = [0, 0]
        highTier = false
        cpAdj = 0
    }
    
    // MARK: - Setters
    public mutating func addPlayer() {
        guard playerLevels.count < 6 else { return }
        playerLevels.append(0)
        
        // add challenge
    }
    
    public mutating func removePlayer() {
        guard playerLevels.count > 2 else { return }
        playerLevels.removeLast()
        updateChallenge()
    }
    
    public mutating func removePlayer(at index: Int) {
        guard playerLevels.count > 2 else { return }
        playerLevels.remove(at: index)
    }
    
    public mutating func updatePlayer(at index: Int, with level: Int) {
        guard index <= playerLevels.count else { return }
        playerLevels[index] = level
        updateChallenge()
    }
    
    public mutating func setHighTier(with high: Bool) {
        highTier = high
    }
    
    fileprivate mutating func updateChallenge() {
        guard playerChallenge.count != playerLevels.count else { return }
        
        if playerChallenge.count < playerLevels.count {
            repeat {
                playerChallenge.append(0)
            } while playerChallenge.count < playerLevels.count
        } else if playerChallenge.count > playerLevels.count {
            repeat {
                playerChallenge.removeLast()
            } while playerChallenge.count > playerLevels.count
        }
    }
    
    fileprivate mutating func setCPAdj(new adjustment: Int) {
        
    }
    
    // MARK: - Other
    public mutating func addPregen() -> String {
            guard playerLevels.count == 2 || playerLevels.count == 3 else {
                return ""
            }
            
            var pregenString: String = ""
            
            if tier.minLevel() == 1 {
                if playerLevels.count == 2 {
                    if totalCP < 8 {
                        setCPAdj(new: 4)
                        pregenString = pregenStringGen(for: 2, minMax: .min)
                    } else {
                        setCPAdj(new: 8)
                        pregenString = pregenStringGen(for: 2, minMax: .max)
                    }
                } else if playerLevels.count == 3 {
                    if totalCP < 12 {
                        setCPAdj(new: 2)
                        pregenString = pregenStringGen(for: 3, minMax: .min)
                    } else {
                        setCPAdj(new: 4)
                        pregenString = pregenStringGen(for: 3, minMax: .max)
                    }
                }
            } else if tier.minLevel() == 3 {
                if playerLevels.count == 2 {
                    if totalCP < 8 {
                        setCPAdj(new: 4)
                        pregenString = pregenStringGen(for: 2, minMax: .min)
                    } else {
                        setCPAdj(new: 8)
                        pregenString = pregenStringGen(for: 2, minMax: .max)
                    }
                } else if playerLevels.count == 3 {
                    if totalCP < 12 {
                        setCPAdj(new: 2)
                        pregenString = pregenStringGen(for: 3, minMax: .min)
                    } else {
                        setCPAdj(new: 4)
                        pregenString = pregenStringGen(for: 3, minMax: .max)
                    }
                }
            } else if tier.minLevel() == 5 {
                if playerLevels.count == 2 {
                    setCPAdj(new: 4)
                    pregenString = pregenStringGen(for: 2, minMax: .min)
                } else if playerLevels.count == 3 {
                    setCPAdj(new: 2)
                    pregenString = pregenStringGen(for: 3, minMax: .max)
                }
            } else if tier.minLevel() >= 7 {
                if playerLevels.count == 2 {
                } else if playerLevels.count == 3 {
                    pregenString = "None"
                    
                    if totalCP < 12 {
                        setCPAdj(new: 2)
                    } else {
                        setCPAdj(new: 4)
                    }
                }
            }
            
            return pregenString
        }
    
    fileprivate mutating func addChallenge(at index: Int, with challenge: Int) {
        guard index <= playerChallenge.count else { return }
        
        playerChallenge[index] = challenge
    }
    
    /// Builds a sring to display the number of pregens needed for the table.
    /// - Parameter pcs: The number of playable characters at the table. Only 2 or 3 characters
    /// - Returns
    fileprivate func pregenStringGen(for pcs: Int, minMax: minMax) -> String {
        var pregenCount: Int = 0
        var pregen: String = "pregen"
        var pregenLvl: Int = 0
        
        switch pcs {
        case 2:
            pregenCount = 2
            
        case 3:
            pregenCount = 1
            
        default:
            pregenCount = 0
        }
        
        if pregenCount > 1 {
            pregen = " pregens"
        }
        
        switch minMax {
        case .max:
            pregenLvl = tier.maxLevel()
            
        case .min:
            pregenLvl = tier.minLevel()
        }
        
        
        return "\(pregenCount) lvl \(pregenLvl) \(pregen)"
    }
    
    

    // MARK: - Calculations
    public func calculateChallenge(for level: Int) -> Int {
            let baseLevel: Int = tier.minLevel()
            
            // Exit if not within the correct level
            
            if level == baseLevel {
                return 2
            } else if level == baseLevel + 1 {
                return 3
            } else if level == baseLevel + 2 {
                return 4
            } else if level == baseLevel + 3 {
                return 6
            } else {
                return 0
            }
        }
    
    fileprivate enum minMax {
        case min, max
    }
}
