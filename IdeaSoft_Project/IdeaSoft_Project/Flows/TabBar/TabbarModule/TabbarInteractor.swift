//
//  TabbarInteractor.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

protocol TabbarBusinessLogic {

}


final class TabbarInteractor: NSObject, TabbarBusinessLogic {

    weak var presenter: TabbarPresenterInput?
    
    deinit { }
}
