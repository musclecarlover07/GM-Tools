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
    
    
    // MARK: - Setters
    public mutating func addPlayer() {
        guard playerLevels.count < 6 else { return }
        playerLevels.append(0)
        
        // add challenge
    }
    
    public mutating func removePlayer() {
        guard playerLevels.count > 2 else { return }
        playerLevels.removeLast()
    }
    
    public mutating func removePlayer(at index: Int) {
        guard playerLevels.count > 2 else { return }
        playerLevels.remove(at: index)
    }
    
    public mutating func updatePlayer(at index: Int, with level: Int) {
        guard index <= playerLevels.count else { return }
        playerLevels[index] = level
    }
    
    fileprivate mutating func updateChallenge() {
        if playerChallenge.count == playerLevels.count {
            
        }
        
        
        
    }
    
    // MARK: - Other
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
    
    fileprivate mutating func addChallenge(at index: Int, with challenge: Int) {
        guard index <= playerChallenge.count else { return }
        
        playerChallenge[index] = challenge
    }
    
    
    
    
    
    
    
}
