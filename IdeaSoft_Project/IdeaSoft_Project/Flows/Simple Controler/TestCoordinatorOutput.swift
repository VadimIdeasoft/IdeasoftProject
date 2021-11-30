//
//  TestCoordinatorOutput.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

protocol TestCoordinatorOutput: Presentable, RootCoordinator {
    var router: RouterType { get }
    var finishFlow: CompletionBlock? { get set }
}
