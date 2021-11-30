//
//  TabbarItem.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

typealias TabbarModel = (title: String, image: UIImage, selectedImage: UIImage, accessibilityIdentifier: String)

enum TabbarItem: Int, CaseIterable, Equatable, Codable {
    case one
    case two
    case three
    
    var model: TabbarModel {
        switch self {
            
        case .one:
            return ( NSLocalizedString("One", comment: ""),
                     UIImage(systemName: "xmark.circle.fill")!.withRenderingMode(.alwaysTemplate),
                     UIImage(systemName: "xmark.circle.fill")!.withRenderingMode(.alwaysTemplate),
                     "First tab bar" )
        case .two:
            return ( NSLocalizedString("Two", comment: ""),
                     UIImage(systemName: "xmark.circle.fill")!.withRenderingMode(.alwaysTemplate),
                     UIImage(systemName: "xmark.circle.fill")!.withRenderingMode(.alwaysTemplate),
                     "Second tab bar" )
            
        case .three:
            return ( NSLocalizedString("Three", comment: ""),
                     UIImage(systemName: "xmark.circle.fill")!.withRenderingMode(.alwaysTemplate),
                     UIImage(systemName: "xmark.circle.fill")!.withRenderingMode(.alwaysTemplate),
                     "Third tab bar" )
        }
    }
    
    func customizeTabbarItem(of viewController: UIViewController?) {
        let model = self.model
        let tabbar = viewController?.tabBarItem
        tabbar?.title = model.title
        tabbar?.image = model.image
        tabbar?.selectedImage = model.selectedImage
        tabbar?.accessibilityIdentifier = model.accessibilityIdentifier
    }
}
