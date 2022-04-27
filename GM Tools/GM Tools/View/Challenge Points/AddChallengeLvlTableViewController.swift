//
//  AddChallengeLvlTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/18/20.
//

import UIKit

class AddChallengeLvlTableViewController: UITableViewController {
    @IBOutlet weak var addLevelTxt: UITextField!
    
    var selectedCell: Int = 0
    var challengePoints: Challenge = Challenge()
    
    var levelPicker: UIPickerView = UIPickerView()
    
    var levelList: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = SystemColor.backgroundColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        SystemColor.setViewBG(view: self.view)
        
        levelList = challengePoints.tier.tierOptions()
        
        levelPicker.delegate = self
        levelPicker.dataSource = self
        addLevelTxt.inputView = levelPicker
        
        let pickerToolBar: UIToolbar = UIToolbar().toolbarPicker(cancel: #selector(cancelPicker), done: #selector(selectPicker))
        addLevelTxt.inputAccessoryView = pickerToolBar
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = SystemColor.backgroundColor()
    }

    // MARK: - Objc
    @objc func cancelPicker() {
        view.endEditing(true)
    }
    
    @objc func selectPicker() {
        if addLevelTxt.isFirstResponder {
            let row: Int = levelPicker.selectedRow(inComponent: 0)
            addLevelTxt.text = "\(levelList[row])"
            challengePoints.updatePlayer(with: levelList[row], at: selectedCell)
        }
        
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputValue: Int = Int(addLevelTxt.text ?? "1") ?? 1
        challengePoints.updatePlayer(with: inputValue, at: selectedCell)
        
        for player in challengePoints.players {
            print("Player:", player.playerLvl)
        }
        
        guard let challengePointsTVC = segue.destination as? ChallengePointsTableViewController else { return }
        challengePointsTVC.challengePoints = challengePoints
    }
}

extension AddChallengeLvlTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(levelList[row])"
    }
}
