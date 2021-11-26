//
//  BasePresenterOutput.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit
//import SVProgressHUD

// Remove all svprogressHUD logic if not needed or install pod if needed

protocol BasePresenterOutput: AnyObject {
    func report(about error: Error?)
    func report(about error: Error?, title: String?)
    //    func showActivity()
    //    func showActivity(masked: Bool)
    //    func showSuccess(status: String?)
    //    func showError(status: String?)
    //    func showProgress(_ progress: Float, status: String?)
    //    func showProgress(_ progress: Float, status: String?, masked: Bool)
    //    func hideActivity()
}


extension BasePresenterOutput where Self: UIViewController {
    //    func showActivity() {
    //        showActivity(masked: false)
    //    }
    //
    //    func showActivity(masked: Bool) {
    //        if masked {
    //            SVProgressHUD.setDefaultMaskType(.black)
    //        }
    //        SVProgressHUD.show()
    //    }
    //
    //    func showSuccess(status: String?) {
    //        SVProgressHUD.setMinimumDismissTimeInterval(0.25)
    //        SVProgressHUD.setMaximumDismissTimeInterval(4)
    //        SVProgressHUD.setForegroundColor(Appearance.style.base1)
    //        SVProgressHUD.showSuccess(withStatus: status)
    //    }
    //
    //    func showError(status: String?) {
    //        SVProgressHUD.setMinimumDismissTimeInterval(0.25)
    //        SVProgressHUD.setMaximumDismissTimeInterval(0.5)
    //        SVProgressHUD.showError(withStatus: status)
    //    }
    //
    //    func hideActivity() {
    //        SVProgressHUD.dismiss()
    //    }
    
    
    //    func showProgress(_ progress: Float, status: String?) {
    //        self.showProgress(progress, status: status, masked: false)
    //    }
    //
    //    func showProgress(_ progress: Float, status: String?, masked: Bool) {
    //        if masked {
    //            SVProgressHUD.setDefaultMaskType(.black)
    //        }
    //        SVProgressHUD.showProgress(progress, status: status)
    //    }
    
    func report(about error: Error?, title: String?) {
        guard let error = error else { return }
        
        let vc = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel, handler: nil)
        //        cancelAction.setValue(Color.dustyOrange, forKey: "titleTextColor")
        vc.addAction(cancelAction)
        
        let handler = { [weak self] () -> Void in
            self?.present(vc, animated: true)
        }
        
        
        handler()
        
    }
    
    func report(about error: Error?) {
        report(about: error, title: nil)
    }
}

