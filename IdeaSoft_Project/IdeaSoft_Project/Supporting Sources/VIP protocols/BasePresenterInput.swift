//
//  BasePresenterInput.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation


protocol BasePresenterInput: AnyObject {
    func report(about error: Error, title: String?)
}

