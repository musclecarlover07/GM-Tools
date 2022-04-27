//
//  ChallengePointsTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/17/20.
//

import UIKit

class ChallengePointsTableViewController: UITableViewController {
    //  Graphic Objects
    @IBOutlet weak var tierTxt: UITextField!
    @IBOutlet weak var playerCollection: UICollectionView!
    @IBOutlet weak var resultsLbl: UILabel!
    @IBOutlet weak var playerCountLbl: UILabel!
    
    // Properties
    var tierPicker: UIPickerView = UIPickerView()
    
    // List Builders
    var tierList: [String] = TierSecond.tierList()
    
    var challengePoints: Challenge = Challenge()
    var selectedCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        // background Color
        SystemColor.setViewBG(view: self.view)
        SystemColor.setCollectionViwBG(for: playerCollection)
        
        // Setting up the Picker View
        // Builds TierSecond Picker
        tierPicker.delegate = self
        tierPicker.dataSource = self
        tierPicker.tag = 0
        tierTxt.inputView = tierPicker
        
        tierTxt.text = challengePoints.tier.description()
        
        // Adds a toolbar to the picker view.
        let tierToolbar: UIToolbar = UIToolbar().toolbarPicker(cancel: #selector(cancelPicker), done: #selector(selectPicker))
        tierTxt.inputAccessoryView = tierToolbar
        
        tierTxt.tintColor = SystemColor.backgroundColor()
        
        updatePlayerCountLbl()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = SystemColor.backgroundColor()
    }
    
    // MARK: - Objc
    @objc func cancelPicker() {
        view.endEditing(true)
    }
    
    @objc func selectPicker() {
        if tierTxt.isFirstResponder {
            let row: Int = tierPicker.selectedRow(inComponent: 0)
            challengePoints.setTier(newTier: tierList[row])
            tierTxt.text = challengePoints.tier.description()
        }
        
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func calculateCP(_ sender: Any) {
        guard tierTxt.text != "No Tier" else {
            let alert: UIAlertController = UIAlertController(title: nil, message: "Tier is required to proceed", preferredStyle: .alert)
            let cancel: UIAlertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        challengePoints.determinePregen()
        challengePoints.calculateCP()
        challengePoints.determineLvlBump()
        updateReults()
        
        tierTxt.tintColor = SystemColor.backgroundColor()
        
        updatePlayerCountLbl()
        playerCollection.reloadData()
    }
    
    @IBAction func unwindToAddCPTVC(_ sender: UIStoryboardSegue) {
        playerCollection.reloadData()
    }
    
    // MARK: - Other
    func updateReults() {
        if challengePoints.highTier == true {
            resultsLbl.text = "High Tier"
        } else {
            resultsLbl.text = "Low Tier"
        }
    }
    
    func updatePlayerCountLbl() {
        playerCountLbl.text = "Count: \(challengePoints.players.count) / 6"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath: IndexPath? = playerCollection.indexPathsForSelectedItems?[0]
        
        if segue.identifier == "addLevel1" {
            let navigationController: UINavigationController = segue.destination as! UINavigationController
            let addChallengeLvlTVC: AddChallengeLvlTableViewController? = navigationController.topViewController as? AddChallengeLvlTableViewController
            
            addChallengeLvlTVC?.selectedCell = indexPath!.row
            addChallengeLvlTVC?.challengePoints = challengePoints
        }
    }
}

extension ChallengePointsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return tierList.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return tierList[row]
            
        default:
            return ""
        }
    }
}

extension ChallengePointsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if challengePoints.players.count == 6 {
            return challengePoints.players.count
        } else {
            return challengePoints.players.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! ChallengeCollectionViewCell

        // Checks for max players and gives option to add more
        if challengePoints.players.count < 6 && indexPath.row == challengePoints.players.count {
            cell.playerLevelLbl.text = "Add Player"
            cell.backgroundColor = .orange
            cell.playerType.isHidden = true
            cell.levelBumpLbl.isHidden = true
            
            return SystemColor.buildCollectionCell(cell: cell)
        } else {
            cell.playerLevelLbl.text = "\(challengePoints.players[indexPath.row].playerLvl)"
            cell.playerType.isHidden = false
            
            // Checks for PC or Pregen
            if challengePoints.players[indexPath.row].pregen == false {
                cell.playerType.text = "PC"
            } else {
                cell.playerType.text = "Pregen"
            }
            
            // Checks for level bump
            if challengePoints.players[indexPath.row].lvlBump == false {
                cell.levelBumpLbl.isHidden = true
            } else {
                cell.levelBumpLbl.text = "Level Bump"
                cell.levelBumpLbl.isHidden = false
            }
            
            return SystemColor.buildCollectionCell(cell: cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: UICollectionViewCell = playerCollection.cellForItem(at: indexPath) else { return }
        
        if challengePoints.players.count < 6 && indexPath.row == challengePoints.players.count {
            challengePoints.addPlayer()
            playerCollection.reloadData()
            updatePlayerCountLbl()
        } else {
            guard tierTxt.text != "No Tier" else {
                let alert: UIAlertController = Alert.createAlert(title: nil, message: "Tier is required to proceed")
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if challengePoints.players.count < 3 {
                performSegue(withIdentifier: "addLevel1", sender: cell)
            } else {
                /*
                 Displays an action sheet
                 Possible Actions
                    * Level Bump
                    Update Level
                    * Delete Character
                 */
                let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let addPlayer: UIAlertAction = UIAlertAction(title: "Add Level", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "addLevel1", sender: nil)
                })
                
                let deletePlayer: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.challengePoints.removePlayer(at: indexPath.row)
                    self.playerCollection.reloadData()
                    self.updatePlayerCountLbl()
                    print("Deleteing...")
                })
                
                let levelBump: UIAlertAction = UIAlertAction(title: "Level Bump", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "lvlBump", sender: nil)
                })
                
                if challengePoints.players[indexPath.row].lvlBump == true {
                    alert.addAction(levelBump)
                }
                
                if challengePoints.players[indexPath.row].pregen == false {
                    alert.addAction(addPlayer)
                } else {
                    // Convert to PC
                    let convertPC: UIAlertAction = UIAlertAction(title: "Convert to PC", style: .default, handler: { _ in
                        var tempPlayer: Player = self.challengePoints.players[indexPath.row]
                        
                        tempPlayer.setPregen(newPregen: false)
                        self.challengePoints.updatePlayer(player: tempPlayer, at: indexPath.row)
                        self.playerCollection.reloadData()
                    })
                    alert.addAction(convertPC)
                }
                
                alert.addAction(deletePlayer)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
