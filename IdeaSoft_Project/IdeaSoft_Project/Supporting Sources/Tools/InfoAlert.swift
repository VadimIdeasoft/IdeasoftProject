//
//  InfoAlert.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation
import UIKit

protocol InfoAlert: AnyObject {
    var router: RouterType { get }
    func showAlert(title: String?, message: String?, alertActions: [UIAlertAction])
}

extension InfoAlert {
    func showAlert(title: String?, message: String?, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertActions.forEach({ alert.addAction($0) })
        
        router.present(alert, animated: true)
    }
}
