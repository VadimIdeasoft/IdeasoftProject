//
//  ZoomModeChecker.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

protocol ZoomModeChecker: InfoAlert {
    func checkForZoomMode()
}

extension ZoomModeChecker {
    func checkForZoomMode() {
        guard UIScreen.main.nativeScale > Device.current.type.nativeScale else {
            return
        }

        let title = NSLocalizedString("'Zoomed' Mode", comment: "")
        let message = NSLocalizedString("Your device is currently on 'Zoomed' mode and therefore could suffer from various issues. To avoid those issues, on the settings menu, change to 'Standard' mode: Settings - Display & Brightness - View - Standard", comment: "")
        
        showAlert(title: title, message: message, alertActions: [
            
            UIAlertAction(title: NSLocalizedString("Go to Settings", comment: ""), style: .default, handler: { (_) in
                guard let url = URL(string: "App-prefs:DISPLAY") else { return }
                UIApplication.shared.open(url)
            }),
            UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        ])
        
        
    }
}
