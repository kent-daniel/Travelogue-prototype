//
//  AlertHelper.swift
//  Travelogue
//
//  Created by kent daniel on 3/6/2023.
//

import UIKit

class AlertHelper{
    static func showAlert(title: String?, message: String?, style: UIAlertController.Style = .alert, actions: [UIAlertAction] = [], viewController: UIViewController) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            if actions.isEmpty {
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
            } else {
                for action in actions {
                    alertController.addAction(action)
                }
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    
    static func showConfirmationAlert(title: String?, message: String?, confirmTitle: String = "Confirm", cancelTitle: String = "Cancel", viewController: UIViewController, confirmHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
            
            showAlert(title: title, message: message, style: .alert, actions: [confirmAction, cancelAction], viewController: viewController)
        }
}
