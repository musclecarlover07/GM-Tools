//
//  AddLevelTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/16/20.
//

import UIKit

class AddLevelTableViewController: UITableViewController {
    @IBOutlet weak var addLevelTxt: UITextField!
    
    var selectedCell: Int = 0
    var apl: AveragePartyLevel = AveragePartyLevel()
    
    //
    var levelPicker: UIPickerView = UIPickerView()
    
    //
    var levelList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = SystemColor.backgroundColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        SystemColor.setViewBG(view: self.view)
        
        //
        levelList = apl.tier.tierOptions()
        
        //
        levelPicker.delegate = self
        levelPicker.dataSource = self
        addLevelTxt.inputView = levelPicker
        
        let textToolBar: UIToolbar = UIToolbar().toolbarPicker(cancel: #selector(cancel), done: #selector(updateRecord))
        addLevelTxt.inputAccessoryView = textToolBar
        
        // Add Toolbar
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = SystemColor.backgroundColor()
    }
    
    // MARK: - Objc
    @objc func cancel() {
        self.view.endEditing(true)
    }
    
    @objc func updateRecord() {
        let row: Int = levelPicker.selectedRow(inComponent: 0)
        apl.updatePlayer(at: selectedCell, with: levelList[row])
        addLevelTxt.text = "\(apl.numOfPlayers[selectedCell])"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputValue: Int = Int(addLevelTxt.text ?? "0") ?? 0
        apl.updatePlayer(at: selectedCell, with: inputValue)
        
        guard let aplTVC = segue.destination as? APLTableViewController else { return }
        aplTVC.apl = apl
    }
}

extension AddLevelTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
