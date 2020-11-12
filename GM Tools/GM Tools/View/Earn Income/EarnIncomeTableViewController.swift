//
//  EarnIncomeTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/7/20.
//

import UIKit

class EarnIncomeTableViewController: UITableViewController {
    // Graphic Objects
    @IBOutlet weak var proficiencyTxt: UITextField!
    @IBOutlet weak var charLevelTxt: UITextField!
    @IBOutlet weak var taskModTxt: UITextField!
    @IBOutlet weak var numOfDaysTxt: UITextField!
    @IBOutlet weak var checkCollection: UICollectionView!
    @IBOutlet weak var finalResultsLbl: UILabel!
    
    // Properties
    var proficiencyPicker: UIPickerView = UIPickerView()
    var levelPicker: UIPickerView = UIPickerView()
    
    // List Builders - for Pickers
    let proficiencyList: [String] = Proficiency.buildList()
    let levelList: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    
    var earnIncome: EarnIncome = EarnIncome()
    var selectedCell: Int = 0
    
    let money: Money = Money()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the Picker Views
        // Builds Proficiency Picker
        proficiencyPicker.delegate = self
        proficiencyPicker.dataSource = self
        proficiencyPicker.tag = 0
        proficiencyTxt.inputView = proficiencyPicker
        
        // Builds Level Picker
        levelPicker.delegate = self
        levelPicker.dataSource = self
        levelPicker.tag = 1
        charLevelTxt.inputView = levelPicker
        
        // Adds a toolbar to the picker view. Allows user to select an option
        // and store it the Earn Income Object for future use
        let pickerToolbar: UIToolbar = UIToolbar().toolbarPicker(cancel: #selector(cancelPicker), done: #selector(selectPicker))
        proficiencyTxt.inputAccessoryView = pickerToolbar
        charLevelTxt.inputAccessoryView = pickerToolbar
        
        // Dismiss the keyboard
        let keyboardToolbar: UIToolbar = UIToolbar().dismissKeyboard(dismiss: #selector(cancelPicker))
        taskModTxt.inputAccessoryView = keyboardToolbar
        numOfDaysTxt.inputAccessoryView = keyboardToolbar
        
        // Sets fields to a value.
        proficiencyTxt.text = proficiencyList[0]
        charLevelTxt.text = "\(levelList[0])"
        taskModTxt.text = "\(earnIncome.taskMod)"
        numOfDaysTxt.text = "\(earnIncome.numOfDays)"
        finalResultsLbl.text = "Update Info, then hit Earn."
    }
    
    // MARK: - Objc Methods
    @objc func cancelPicker() {
        if numOfDaysTxt.isFirstResponder {
            earnIncome.setNumOfDays(addDays: Int(numOfDaysTxt.text ?? "1") ?? 1)
            checkCollection.reloadData()
            numOfDaysTxt.text = "\(earnIncome.numOfDays)"
        } else if taskModTxt.isFirstResponder {
// Set task mod in Earn Income
            earnIncome.setTaskMod(newTaskMod: Int(numOfDaysTxt.text ?? "0") ?? 0)
            checkCollection.reloadData()
            taskModTxt.text = "\(earnIncome.taskMod)"
        }
        
        checkCollection.reloadData()
        view.endEditing(true)
    }
    
    @objc func selectPicker() {
        
        // When the different text fields, with pickers, are the first responder
        // will help make sure that the correct value is placed in the correct
        // field. And updates the Earn Income Object
        if proficiencyTxt.isFirstResponder {
            let row: Int = proficiencyPicker.selectedRow(inComponent: 0)
            earnIncome.setProficiency(newProficiency: proficiencyList[row])
            proficiencyTxt.text = earnIncome.proficiency.description()
        } else if charLevelTxt.isFirstResponder {
            let row: Int = levelPicker.selectedRow(inComponent: 0)
            earnIncome.setCharLevel(newLevel: levelList[row])
            charLevelTxt.text = "\(earnIncome.charLevel)"
        }
        
        checkCollection.reloadData()
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func earn(_ sender: Any) {
        // Calculate all checks ---
//        finalResultsLbl.text = earnIncome.separateMoney(newGold: earnIncome.calculateTotalIncome(with: earnIncome.numOfChecks))
        finalResultsLbl.text = money.separateMoney(newGold: earnIncome.calculateTotalIncome(with: earnIncome.numOfChecks))
    }
    
    @IBAction func resetFields(_ sender: Any) {
        // Resets all fields to the minimum
        earnIncome.setProficiency(newProficiency: "Not Trained")
        earnIncome.setCharLevel(newLevel: 1)
        earnIncome.setNumOfDays(addDays: 1)
        earnIncome.setTaskMod(newTaskMod: 0)
        earnIncome.updateCheck(with: 0, at: 0)
        
        // displays the values of the object to the correct field
        proficiencyTxt.text = earnIncome.proficiency.description()
        charLevelTxt.text = "\(earnIncome.charLevel)"
        taskModTxt.text = "\(earnIncome.taskMod)"
        numOfDaysTxt.text = "\(earnIncome.numOfDays)"
        
        // Resets the finalResultsLbl to a new State
        finalResultsLbl.text = "Update Info, then hit Earn."
        
        // Resets pickerviews to first option
        proficiencyPicker.selectRow(0, inComponent: 0, animated: false)
        proficiencyPicker.selectRow(0, inComponent: 0, animated: false)
        
        checkCollection.reloadData()
    }
    
    @IBAction func unwindToEarnIncome(_ sender: UIStoryboardSegue) {
        checkCollection.reloadData()
    }
    
    // Segue update the cell with the result and check
    // ---- //
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Sets up passing objects and values to the Check Update TVC. This way
        // the user can add the apporiate check. 
        let indexPath: IndexPath? = checkCollection.indexPathsForSelectedItems?[0]
        let navigationController: UINavigationController = segue.destination as! UINavigationController
        let checkUpdateTVC: CheckUpdateTableViewController? = navigationController.topViewController as? CheckUpdateTableViewController
        
        checkUpdateTVC?.selectedCell = indexPath!.row
        checkUpdateTVC?.earnIncome = earnIncome
    }
}

// MARK: - Extensions
extension EarnIncomeTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return proficiencyList.count
            
        case 1:
            return levelList.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return proficiencyList[row]
            
        case 1:
            return "\(levelList[row])"
            
        default:
            return ""
        }
    }
}

extension EarnIncomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return earnIncome.numOfChecks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkCell", for: indexPath) as! EarnIncomeCollectionViewCell
        
        cell.backgroundColor = .yellow
        cell.layer.cornerRadius = 8
        
        // Sets the checkResultsLbl with the value
        // if 0 then Add Check
        if earnIncome.numOfChecks[indexPath.row] == 0 {
            cell.checkresultTxt.text = "Add Check"
        } else {
            cell.checkresultTxt.text = "\(earnIncome.numOfChecks[indexPath.row])"
        }
        
        // Format double to be only 2 decimal points
        let resultStr: String = String(format: "%.2f", earnIncome.checkResults[indexPath.row])
        cell.resultsTxt.text = "\(earnIncome.daysArray[indexPath.row])" + " day(s): " + resultStr
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: UICollectionViewCell = checkCollection.cellForItem(at: indexPath) else { return }
        performSegue(withIdentifier: "addCheck", sender: cell)
    }
    
}
