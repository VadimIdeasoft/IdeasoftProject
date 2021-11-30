//
//  TestFactoryProtocol.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

protocol TestFactoryProtocol {
    func makeFirstController(with color: UIColor) -> Presentable
}

extension TestFactoryProtocol {
    func makeFirstController(with color: UIColor) -> Presentable {
        
        let vc = TestViewController.controllerFromStoryboard(.test)
        vc.view.backgroundColor = color
        
        return vc
    }
}
