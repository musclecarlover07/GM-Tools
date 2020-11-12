//
//  APLTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/15/20.
//

import UIKit

class APLTableViewController: UITableViewController {
    // Graphic Objects
    @IBOutlet weak var seasonTxt: UITextField!
    @IBOutlet weak var tierTxt: UITextField!
    @IBOutlet weak var playerCollection: UICollectionView!
    @IBOutlet weak var playerCountLbl: UILabel!
    @IBOutlet weak var resultsLbl: UILabel!
    
    // Properties
    var tierPicker: UIPickerView = UIPickerView()
    var seasonPicker: UIPickerView = UIPickerView()
    
    // List Builders - for pickers
    var seasonList: [String] = Season.seasonList()
    var tierList: [String] = Tier.tierList()
    
    var apl: AveragePartyLevel = AveragePartyLevel()
    var selectedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the Picker Views
        // Builds Tier Picker
        tierPicker.delegate = self
        tierPicker.dataSource = self
        tierPicker.tag = 0
        tierTxt.inputView = tierPicker
        
        // Builds Season Picker
        seasonPicker.delegate = self
        seasonPicker.dataSource = self
        seasonPicker.tag = 1
        seasonTxt.inputView = seasonPicker
        
        // Adds a toolbar to the picker view. Allows user to select an option
        // and store it the AveragePartyLevel object for future use
        let pickerToolbar: UIToolbar = UIToolbar().toolbarPicker(cancel: #selector(cancelPicker), done: #selector(selectPicker))
        tierTxt.inputAccessoryView = pickerToolbar
        seasonTxt.inputAccessoryView = pickerToolbar
        
        // Sets fields ro a value
        tierTxt.text = apl.tier.description()
        seasonTxt.text = apl.season.description()
        
        // Updates the playerCountLbl
        updatePlayerCountLbl()
    }
    
    // MARK: - Objc
    @objc func cancelPicker() {
        
    }

    /// When the different text fields, with pickers, are the first responder will help make sure that the correct
    /// value is placed in the correct field. And updates the Earn Income Object
    @objc func selectPicker() {
        if tierTxt.isFirstResponder {
            let row: Int = tierPicker.selectedRow(inComponent: 0)
            apl.setTier(newTier: tierList[row])
            tierTxt.text = apl.tier.description()
        } else if seasonTxt.isFirstResponder {
            let row: Int = seasonPicker.selectedRow(inComponent: 0)
            apl.setSeason(newSeason: seasonList[row])
            seasonTxt.text = apl.season.description()
        }
        
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func unwindToAPLTVC(_ sender: UIStoryboardSegue) {
        playerCollection.reloadData()
        updateResults()
    }
    
    // MARK: - Other
    func updatePlayerCountLbl() {
        playerCountLbl.text = "Count: \(apl.numOfPlayers.count) / 7"
    }
    
    func updateResults() {
        resultsLbl.text = apl.calculateTbl()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath: IndexPath? = playerCollection.indexPathsForSelectedItems?[0]
        let navigationController: UINavigationController = segue.destination as! UINavigationController
        let addLevelTVC: AddLevelTableViewController? = navigationController.topViewController as? AddLevelTableViewController
        
        addLevelTVC?.selectedCell = indexPath!.row
        addLevelTVC?.apl = apl
    }
}

extension APLTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return tierList.count
            
        case 1:
            return seasonList.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return tierList[row]
            
        case 1:
            return seasonList[row]
            
        default:
            return ""
        }
    }
}

extension APLTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if apl.numOfPlayers.count == 7 {
            return apl.numOfPlayers.count
        } else {
            return apl.numOfPlayers.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! APLCollectionViewCell
        cell.backgroundColor =  .yellow
        cell.layer.cornerRadius = 8
        
        if apl.numOfPlayers.count < 7 && indexPath.row == apl.numOfPlayers.count {
            cell.playerLvlLbl.text = "Add Player"
            cell.backgroundColor = .orange
            
            return cell
        } else {
            cell.playerLvlLbl.text = "\(apl.numOfPlayers[indexPath.row])"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if apl.numOfPlayers.count < 7 && indexPath.row == apl.numOfPlayers.count {
            apl.addPlayer()
            playerCollection.reloadData()
            updatePlayerCountLbl()
        } else {
            print("num of players count:", apl.numOfPlayers.count)
            if apl.numOfPlayers.count < 4 {
                performSegue(withIdentifier: "addLevel", sender: nil)
            } else {
                let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let addUser: UIAlertAction = UIAlertAction(title: "Add Level", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "addLevel", sender: nil)
                })
                
                let deleteUser: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.apl.deleteUser(at: indexPath.row)
                    self.playerCollection.reloadData()
                    self.updatePlayerCountLbl()
                })
                
                alert.addAction(addUser)
                alert.addAction(deleteUser)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("Cancel") }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
//            if indexPath.row < 3 {
//                print("Selected")
//            } else {
//                let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//                let addUser: UIAlertAction = UIAlertAction(title: "Add Level", style: .default, handler: { _ in
//                    self.performSegue(withIdentifier: "addLevel", sender: nil)
//                })
//
//                let deleteUser: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
//                    self.apl.deleteUser(at: indexPath.row)
//                    self.playerCollection.reloadData()
//                    self.updatePlayerCountLbl()
//                })
//
//                alert.addAction(addUser)
//                alert.addAction(deleteUser)
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("Cancel") }))
//
//                self.present(alert, animated: true, completion: nil)
//            }
        }
    }
}
