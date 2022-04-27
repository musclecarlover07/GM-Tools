//
//  AveragePartyLevel.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/14/20.
//

import Foundation

/// Average Party Level object, Handels everything for Pathfinder 1st edtion Average Party Level.
struct AveragePartyLevel {
    /// An array holding the number of players sitting at the table. The minimum count is 2 and the maximum
    /// is 7. The array should never drop below 2 or hold more than 7 . An array of integers to display each
    /// players level.
    private(set) var numOfPlayers: [Int]
    
    
    private(set) var season: Season
    
    
    private(set) var tier: Tier
    
    
    private var averagePL: Double {
        get {
            let total: Double = Double(numOfPlayers.reduce(0, +))
            return Double(total / Double(numOfPlayers.count))
        }
    }
    
    init() {
        numOfPlayers = [0, 0, 0]
        season = .noSeason
        tier = .noTier
    }
    
    // MARK: -Setters
    
    /// Sets the Season
    /// - Parameter newSeason: The season of the scenario being played
    public mutating func setSeason(newSeason: String) {
        season = Season.fromString(newSeason)
    }
    
    /// Sets the Tier
    /// - Parameter newTier: The tier of the scenario being played
    public mutating func setTier(newTier: String) {
        tier = Tier.fromString(newTier)
    }
    
    /// Adds a player to the current pool. This does not update the players level. Simply adds another player
    /// to the pool while verifying no more than 7 players.
    public mutating func addPlayer() {
        guard numOfPlayers.count < 7 else { return }
        numOfPlayers.append(0)
    }
    
    /// Removes the  last player from the array. Does not update any info. Simply removes a player from the
    /// pool while verifying no less than 3 players
    public mutating func removePlayer() {
        guard numOfPlayers.count > 3 else { return }
        numOfPlayers.removeLast()
    }
    
    /// Updates a characters level at a specific point 
    public mutating func updatePlayer(at index: Int, with level: Int) {
        guard index <=  numOfPlayers.count else { return }
        numOfPlayers[index] = level
    }
    
    public func calculateTbl() -> String {
        let lowTier: String = "Low tier"
        let hightTier: String = "High Tier"
        let fourPlayer: String = "Play with a four player adjustment."
        
        // Regardless of season these are always true
        // Less than 3 playes. Should never trigger. Just in case.
        guard numOfPlayers.count > 2 else {
            return "Not enough players for a legal table."
        }
        
        // There are more 7 players. This should never trigger. Just in case.
        guard numOfPlayers.count < 7 else {
            return "There are too many players."
        }
        
        let midTier: Double = Double(tier.setSubTiers())
        
        // if -> low tier
        // else -> high tier
        // else -> inbewteen - based on the the season the table is playing
        if averagePL < midTier - 0.6 {
            return lowTier
        } else if averagePL > midTier + 0.6 {
            return hightTier
        } else if averagePL == midTier + 0.5 || averagePL == midTier - 0.5 {
            switch season {
            case .noSeason:
                return "Error. You did something wrong! Try again!"
            
            case .zeroThree:
                if numOfPlayers.count == 4 || numOfPlayers.count == 5 {
                    return lowTier
                } else if numOfPlayers.count == 6 || numOfPlayers.count == 7 {
                    return hightTier
                }
                
            case .fourPlus:
                if numOfPlayers.count == 4 {
                    return lowTier
                } else if numOfPlayers.count > 4 && numOfPlayers.count < 8 {
                    var count: Int = 0
                    
                    for i in numOfPlayers {
                        if i <= tier.setSubTiers() {
                            count += 1
                        }
                    }
                    
                    guard count != numOfPlayers.count else {
                        return "Players can choose tto play" + lowTier
                    }
                    
                    return fourPlayer
                }
            }
        }
        
        return ""
    }
    
    public mutating func deleteUser(at index: Int) {
        numOfPlayers.remove(at: index)
    }
}
