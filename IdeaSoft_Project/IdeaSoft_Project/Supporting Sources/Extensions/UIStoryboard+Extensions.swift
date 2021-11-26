//
//  UIStoryboard+Extensions.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

public enum StoryboadType: String, Iteratable {
    case main
    
    var filename: String { return rawValue.capitalized }
}

typealias Storyboard = UIStoryboard

extension Storyboard {
    convenience init(_ storyboard: StoryboadType) {
        self.init(name: storyboard.filename, bundle: nil)
    }
    
    /// Instantiates and returns the view controller with the specified identifier.
    ///
    /// - Parameter identifier: uniquely identifies equals to Class name
    /// - Returns: The view controller corresponding to the specified identifier string. If no view controller is associated with the string, this method throws an exception.
    public func instantiateViewController<T>(_ identifier: T.Type) -> T where T: UIViewController {
        let className = String(describing: identifier)
        guard let vc =  self.instantiateViewController(withIdentifier: className) as? T else {
            fatalError("Cannot find controller with identifier \(className)")
        }
        return vc
    }
}
