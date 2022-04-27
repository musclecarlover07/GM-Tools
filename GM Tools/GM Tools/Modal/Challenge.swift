//
//  Challenge.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/11/20.
//

import Foundation

struct Challenge {
    private(set) var tier: TierSecond
    private(set) var players: [Player]
    private(set) var highTier: Bool
    private(set) var cpAdj: Int
    
    private var playerCP: Int {
        get {
            var cp: Int = 0
            
            for player in players {
                cp += player.challengePoints
            }
            
            return cp
        }
    }
    
    private var finalCP: Int {
        get {
            return playerCP + cpAdj
        }
    }

    init() {
        tier = .noTier
        players = [Player(), Player()]
        
        highTier = false
        cpAdj = 0
    }
    
    // MARK: - Setters
    public mutating func setTier(newTier: String) {
        tier = TierSecond.fromString(newTier)
        
        // Check the min player count
        // tier 7+ min = 3 else min = 2
    }
    
    public mutating func addPlayer() {
        guard players.count < 6 else { return }
        
        players.append(Player())
    }
    
    public mutating func removePlayer() {
        if tier.minLevel() < 7 {
            guard players.count < 3 else { return }
            players.removeLast()
        } else {
            guard players.count < 4 else { return }
            players.removeLast()
        }
    }
    
    public mutating func removePlayer(at index: Int) {
        guard players.count >= index else { print("guarded"); return }
        print("unguarded")
        
        if tier.minLevel() < 7 {
            guard players.count > 2 else { print("guarded <4"); return }
            print("<4")
            players.remove(at: index)
        } else {
            guard players.count > 3 else { print("guarded <5"); return }
            print("<5")
            players.remove(at: index)
        }
    }
    
    public mutating func setHighTier(newHighTier: Bool) {
        highTier = newHighTier
    }
    
    public mutating func setCPAdj(newAdju: Int) {
        guard newAdju > 0 else {
            cpAdj = 0
            return
        }
        
        cpAdj = newAdju
    }
    
    public mutating func updatePlayer(with lvl: Int, at index: Int) {
        guard players.count >= index else { return }
        
        players[index].setPlayerLvl(newLvl: lvl)
        players[index].setChallengePoints(newCP: calculateChallenge(for: players[index].playerLvl))
    }
    
    fileprivate mutating func addplayer(newPlayer: Player) {
        guard players.count < 6 else { return }
        players.append(newPlayer)
    }
    
    public mutating func updatePlayer(player: Player, at index: Int) {
        players[index] = player
    }
    
    // MARK: - Other
    public mutating func determinePregen() {
        guard players.count == 2 || players.count == 3 else { return }
        
        switch tier.minLevel() {
        case 1:
            if players.count == 2 {
                print(playerCP)
                if playerCP < 8 {
                    setCPAdj(newAdju: 4)
                    
                    repeat {
                        var tempPlayer = Player()
                        tempPlayer.setPlayerLvl(newLvl: tier.minLevel())
                        tempPlayer.setPregen(newPregen: true)
                        addplayer(newPlayer: tempPlayer)
                    } while players.count < 4
                } else {
                    setCPAdj(newAdju: 8)
                    
                    repeat {
                        var tempPlayer = Player()
                        tempPlayer.setPlayerLvl(newLvl: tier.maxLevel())
                        tempPlayer.setPregen(newPregen: true)
                        addplayer(newPlayer: tempPlayer)
                    } while players.count < 4
                }
            } else if players.count == 3 {
                if playerCP < 12 {
                    setCPAdj(newAdju: 2)
                    
                    var tempPlayer: Player = Player()
                    tempPlayer.setPlayerLvl(newLvl: tier.minLevel())
                    tempPlayer.setPregen(newPregen: true)
                    addplayer(newPlayer: tempPlayer)
                } else {
                    setCPAdj(newAdju: 4)
                    
                    var tempPlayer: Player = Player()
                    tempPlayer.setPlayerLvl(newLvl: tier.maxLevel())
                    tempPlayer.setPregen(newPregen: true)
                    addplayer(newPlayer: tempPlayer)
                }
            }
            
        case 3:
            if players.count == 2 {
                if playerCP < 8 {
                    setCPAdj(newAdju: 4)
                    
                    repeat {
                        var tempPlayer = Player()
                        tempPlayer.setPlayerLvl(newLvl: tier.minLevel())
                        tempPlayer.setPregen(newPregen: true)
                        addplayer(newPlayer: tempPlayer)
                    } while players.count < 4
                } else {
                    setCPAdj(newAdju: 8)
                    
                    repeat {
                        var tempPlayer = Player()
                        tempPlayer.setPlayerLvl(newLvl: tier.maxLevel())
                        tempPlayer.setPregen(newPregen: true)
                        addplayer(newPlayer: tempPlayer)
                    } while players.count < 4
                }
            } else if players.count == 3 {
                if playerCP < 12 {
                    setCPAdj(newAdju: 2)
                    
                    var tempPlayer: Player = Player()
                    tempPlayer.setPlayerLvl(newLvl: tier.minLevel())
                    tempPlayer.setPregen(newPregen: true)
                    addplayer(newPlayer: tempPlayer)
                } else {
                    setCPAdj(newAdju: 4)
                    
                    var tempPlayer: Player = Player()
                    tempPlayer.setPlayerLvl(newLvl: tier.maxLevel())
                    tempPlayer.setPregen(newPregen: true)
                    addplayer(newPlayer: tempPlayer)
                }
            }
            
        case 5:
            if players.count == 2 {
                setCPAdj(newAdju: 4)
                
                repeat {
                    var tempPlayer = Player()
                    tempPlayer.setPlayerLvl(newLvl: tier.minLevel())
                    tempPlayer.setPregen(newPregen: true)
                    addplayer(newPlayer: tempPlayer)
                } while players.count < 4
            } else if players.count == 3 {
                setCPAdj(newAdju: 2)
                
                repeat {
                    var tempPlayer = Player()
                    tempPlayer.setPlayerLvl(newLvl: tier.maxLevel())
                    tempPlayer.setPregen(newPregen: true)
                    addplayer(newPlayer: tempPlayer)
                } while players.count < 4
            }
            
        case tier.minLevel() where tier.minLevel() >= 7:
            if players.count == 2 {
                // Nothing
            } else if players.count == 3 {
                if playerCP < 12 {
                    setCPAdj(newAdju: 2)
                } else {
                    setCPAdj(newAdju: 4)
                }
            }
            
        default:
            break
        }
    }
    
    public mutating func calculateCP() {
        print("total cp: \(finalCP)")
        if finalCP < 16 {
            setHighTier(newHighTier: false)
        } else if finalCP > 18 {
            setHighTier(newHighTier: true)
        } else {
            if players.count <= 4 {
                setHighTier(newHighTier: true)
            } else {
                setHighTier(newHighTier: false)
            }
        }
    }
    
    public mutating func determineLvlBump() {
        var count:Int = 0
        
        for player in players {
            var tempPlayer: Player = player
            if tempPlayer.pregen == true {
                print("determineLblBump -> True")
                continue
            } else {
                print("determineLblBump -> False")
                if player.playerLvl == tier.minLevel() && highTier == true {
                    print("determineLblBump -> False, True")
                    tempPlayer.setLvlBump(newBump: true)
                } else {
                    print("determineLblBump -> False, False")
                    tempPlayer.setLvlBump(newBump: false)
                }
            }
            players[count] = tempPlayer
            
            count += 1
        }
    }
    
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
}

// Add new File
struct Player {
    private(set) var playerLvl: Int
    private(set) var challengePoints: Int
    private(set) var pregen: Bool
    private(set) var lvlBump: Bool
    
    init() {
        playerLvl = 1
        challengePoints = 0
        pregen = false
        lvlBump = false
    }
    
    // MARK: - Setters
    public mutating func setPlayerLvl(newLvl: Int) {
        guard pregen == false else { return }
        
        guard newLvl > 0 || newLvl < 21 else {
            playerLvl = 1
            return
        }
        
        playerLvl = newLvl
    }
    
    public mutating func setChallengePoints(newCP: Int) {
        guard newCP == 2 || newCP == 3 || newCP == 4 || newCP == 6 else {
            challengePoints = 2
            return
        }
        
        challengePoints = newCP
    }
    
    public mutating func setPregen(newPregen: Bool) {
        pregen = newPregen
    }
    
    public mutating func setLvlBump(newBump: Bool) {
        lvlBump = newBump
    }
}
