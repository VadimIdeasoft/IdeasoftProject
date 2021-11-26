//
//  TabbarAssembly.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

final class TabbarAssembly {
    static func assembly(with output: TabbarPresenterOutput) -> TabbarModule {
        let interactor = TabbarInteractor()
        let presenter  = TabbarPresenter()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output     = output
        output.presenter     = presenter
    
        return presenter
    }
}
