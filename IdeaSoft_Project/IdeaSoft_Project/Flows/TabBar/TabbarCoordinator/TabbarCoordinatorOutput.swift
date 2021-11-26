//
//  TabbarCoordinatorOutput.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation

protocol TabbarCoordinatorOutput: Presentable {
    var finishFlow: CompletionBlock? { get set }
}
