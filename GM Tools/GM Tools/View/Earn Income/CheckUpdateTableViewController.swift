//
//  CheckUpdateTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/9/20.
//

import UIKit

class CheckUpdateTableViewController: UITableViewController {
    @IBOutlet weak var checkTxt: UITextField!
    
    // Properties to be passed to and back
    var selectedCell: Int = 0
    var cellValue: String = ""
    var earnIncome: EarnIncome = EarnIncome()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = SystemColor.backgroundColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tableView.delegate = self
        
        SystemColor.setViewBG(view: self.view)
        
        let checkToolbar: UIToolbar = UIToolbar().toolbarPicker(cancel: #selector(cancelkeyboard), done: #selector(updateKeyboard))
        checkTxt.inputAccessoryView = checkToolbar
        
        checkTxt.tintColor = SystemColor.backgroundColor()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = SystemColor.backgroundColor()
    }
    
    // MARK: - Objc
    @objc func cancelkeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateKeyboard() {
        earnIncome.updateCheck(with: Int(checkTxt.text ?? "0") ?? 0, at: selectedCell)
        checkTxt.text = "\(earnIncome.numOfChecks[selectedCell])"
        
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare")
        let inputValue = Int(checkTxt.text ?? "0") ?? 0
        earnIncome.updateCheck(with: inputValue, at: selectedCell)
        
        guard let earnIncomeTVC = segue.destination as? EarnIncomeTableViewController else { return }
        earnIncomeTVC.earnIncome = earnIncome
    }
}
