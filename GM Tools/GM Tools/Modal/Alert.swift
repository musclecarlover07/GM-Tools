//
//  Alert.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/21/20.
//

import Foundation
import UIKit

struct Alert {
    // Generates a generic alert with a simple dismiss
    static func createAlert(title: String?, message: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        
        return alert
    }
}
