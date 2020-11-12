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
        
        //
        levelList = apl.tier.tierOptions()
        
        //
        levelPicker.delegate = self
        levelPicker.dataSource = self
        addLevelTxt.inputView = levelPicker
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
