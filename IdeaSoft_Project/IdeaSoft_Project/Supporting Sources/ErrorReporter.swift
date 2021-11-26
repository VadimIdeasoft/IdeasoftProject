//
//  ErrorReporter.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

//import SVProgressHUD
import UIKit

protocol ErrorReporter {
    var router : RouterType { get }
    var alertTitle: String? { get }
    func showErrorAlert(_ error: Error, title: String?)
    func showErrorAlert(_ error: Error, title: String?, button: String?)
    func showErrorAlert(_ error: Error, title: String?, onCancel: @escaping CompletionBlock)
}

extension ErrorReporter {
    func showErrorAlert(_ error: Error, title: String?) {
        guard error.code != .requestTimeOut else {
            return
        }
        showErrorAlert(error, title: title, onCancel: {})
    }
    
    func showErrorAlert(_ error: Error, title: String?, onCancel: @escaping CompletionBlock) {
        guard error.code != .requestTimeOut else {
            return
        }
//        if SVProgressHUD.isVisible() {
//            SVProgressHUD.dismiss()
//        }
        let title = title ?? alertTitle
        let vc = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { _ in
            onCancel()
        })
        vc.addAction(cancelAction)
        vc.modalPresentationCapturesStatusBarAppearance = true
        router.present(vc, animated: true)
    }
    
    func showErrorAlert(_ error: Error, title: String?, button: String?) {
        guard error.code != .requestTimeOut else {
            return
        }
//        if SVProgressHUD.isVisible() {
//            SVProgressHUD.dismiss()
//        }
        let title = title ?? alertTitle
        let btn = button ?? NSLocalizedString("OK", comment: "")
        let vc = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: btn, style: .cancel, handler: { _ in
//            onCancel()
        })
        vc.addAction(cancelAction)
        vc.modalPresentationCapturesStatusBarAppearance = true
        router.present(vc, animated: true)
    }
    
    func showErrorAlert(router: RouterType) -> (_ error: Error, _ title: String?) -> Void {
        return { error, title in
            
            guard error.code != .requestTimeOut else {
                return
            }
//            if SVProgressHUD.isVisible() {
//                SVProgressHUD.dismiss()
//            }
            let title = title ?? NSLocalizedString("Error", comment: "")
            let vc = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { _ in
            })
            vc.addAction(cancelAction)
            vc.modalPresentationCapturesStatusBarAppearance = true
            router.present(vc, animated: true)
        }
    }
}
