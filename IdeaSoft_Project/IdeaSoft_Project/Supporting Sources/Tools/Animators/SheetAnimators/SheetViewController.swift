//
//  SheetViewController.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

class SheetViewController: UIViewController, Embeddable {
    var preferredHandleViewColor: UIColor? = UIColor.lightGray
    
    func estimatedContentSize(for parentSize: CGSize) -> CGSize {
        view.layoutIfNeeded()
        var contentSize = view.systemLayoutSizeFitting(parentSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        contentSize.width = ceil(contentSize.width)
        contentSize.height = ceil(contentSize.height)
        return contentSize
    }
    
    var extendsContentUnderBottomSafeArea: Bool {
        return true
    }
    
    var extendsContentUnderTopSafeArea: Bool {
        return true
    }
}

