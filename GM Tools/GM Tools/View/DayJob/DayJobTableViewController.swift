//
//  DayJobTableViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 10/27/20.
//

import UIKit

class DayJobTableViewController: UITableViewController {
    // Outlets
    @IBOutlet weak var checkTxt: UITextField!
    @IBOutlet weak var boostSwitch: UISwitch!
    @IBOutlet weak var resultsLbl: UILabel!
    
    var dayJob: DayJob = DayJob()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets the keyboard toolbar
        let keyboardToolbar: UIToolbar = UIToolbar().dismissKeyboard(dismiss: #selector(addCheck))
        checkTxt.inputAccessoryView = keyboardToolbar
        
        // Adds target to swictch
        boostSwitch.addTarget(self, action: #selector(self.updateBoost), for: .valueChanged)
    }
    
    // MARK: - Objc Methods
    @objc func addCheck() {
        if checkTxt.isFirstResponder {
            dayJob.setCheck(newCheck: Int(checkTxt.text ?? "0") ?? 0)
        }
        
        update()
        view.endEditing(true)
    }
    
    @objc func updateBoost(sender: UISwitch!) {
        if sender.isOn {
            dayJob.setFifty(newFifty: true)
        } else {
            dayJob.setFifty(newFifty: false)
        }
        
        update()
        view.endEditing(true)
    }
    
    func update() {
        resultsLbl.text = dayJob.calculateDayJob()
    }
    

    @IBAction func printDay(_ sender: Any) {
        print(dayJob.fiftyPercent)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
