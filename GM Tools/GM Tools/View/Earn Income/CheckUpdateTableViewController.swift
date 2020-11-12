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
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputValue = Int(checkTxt.text ?? "0") ?? 0
        earnIncome.updateCheck(with: inputValue, at: selectedCell)
        
        guard let earnIncomeTVC = segue.destination as? EarnIncomeTableViewController else { return }
        earnIncomeTVC.earnIncome = earnIncome
    }
}
