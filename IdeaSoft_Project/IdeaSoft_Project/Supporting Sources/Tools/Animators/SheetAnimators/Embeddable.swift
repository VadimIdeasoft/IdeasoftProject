//
//  Embeddable.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

protocol Embeddable: UIViewController {
    func estimatedContentSize(for parentSize: CGSize) -> CGSize
    var extendsContentUnderTopSafeArea: Bool { get }
    var extendsContentUnderBottomSafeArea: Bool { get }
    var alwaysFullScreen: Bool { get }
    var preferredHandleViewColor: UIColor? { get }
}

extension Embeddable {
    var alwaysFullScreen: Bool {
        return false
    }
}

final class EmbeddableSheetModalViewController: UIViewController {
    var lightStatusBar: Bool = true
    let viewController: Embeddable
    private let backgroundColor: UIColor
    private var contentBottomConstraint: NSLayoutConstraint!
    private let contentCornerRadius: CGFloat
    
    var shouldShowHandle: Bool = false
    
    var handleView: UIView?
    var handleContainerView: UIView?
    
    private (set) lazy var contentView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = contentCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewController: Embeddable, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0.0) {
        self.viewController = viewController
        self.backgroundColor = backgroundColor
        self.contentCornerRadius = cornerRadius
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return lightStatusBar ? .lightContent : .default
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.addSubview(contentView)
        contentView.backgroundColor = backgroundColor
        
        
//        handleView = UIView()

        
//        handleView = handleContainerView
        
        if shouldShowHandle {
//            handleView?.translatesAutoresizingMaskIntoConstraints = false
//            handleView?.backgroundColor = viewController.preferredHandleViewColor ?? .lightGray
//            handleView?.layer.cornerRadius = 2.0
//
//            contentView.addSubview(handleView!)
            
            
            let handleContainerView = UIView()
            let handlePanView = UIView()
            handlePanView.backgroundColor = viewController.preferredHandleViewColor ?? .lightGray
            handleContainerView.backgroundColor = .clear
            
            
            handlePanView.layer.cornerRadius = 2.0
            handlePanView.translatesAutoresizingMaskIntoConstraints = false
            handleContainerView.translatesAutoresizingMaskIntoConstraints = false
            handleContainerView.addSubview(handlePanView)
            
            NSLayoutConstraint.activate([ handlePanView.widthAnchor.constraint(equalToConstant: 32.0),
                                          handlePanView.heightAnchor.constraint(equalToConstant: 4.0),
                                          handlePanView.topAnchor.constraint(equalTo: handleContainerView.topAnchor, constant: 8.0),
                                          handlePanView.centerXAnchor.constraint(equalTo: handleContainerView.centerXAnchor) ])
            
//            handleContainerView.bringSubviewToFront(handlePanView)
            self.handleContainerView = handleContainerView
            contentView.addSubview(handleContainerView)
        }
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        let controllerView = viewController.view!
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentBottomConstraint = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        let boundingSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingExpandedSize.height)
        let childContentSize = viewController.estimatedContentSize(for: boundingSize)
        
        let childHeightConstraint = controllerView.heightAnchor.constraint(equalToConstant: childContentSize.height)
        childHeightConstraint.priority = .defaultHigh
        
        let topConstraint: NSLayoutConstraint
        
        if !viewController.extendsContentUnderTopSafeArea && shouldShowHandle {
            topConstraint = controllerView.topAnchor.constraint(equalTo: self.handleContainerView!.bottomAnchor, constant: 0.0)
        } else {
            topConstraint = controllerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        }
        
        let bottomConstraint: NSLayoutConstraint
        
        if viewController.extendsContentUnderBottomSafeArea {
            bottomConstraint = contentView.bottomAnchor.constraint(equalTo: controllerView.bottomAnchor)
        } else {
            bottomConstraint = contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: controllerView.bottomAnchor)
        }
        
        let contentTopConstraint: NSLayoutConstraint
        
        if viewController.alwaysFullScreen {
            contentTopConstraint = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        } else {
            contentTopConstraint = contentView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
        }
        
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            controllerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: controllerView.trailingAnchor),
            childHeightConstraint,
            
            //            handleView.widthAnchor.constraint(equalToConstant: 50.0),
            //            handleView.heightAnchor.constraint(equalToConstant: 4.0),
            //            handleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            //            handleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            contentTopConstraint,
            contentBottomConstraint
        ])
        
        if shouldShowHandle, let handleView = self.handleContainerView {
            
            NSLayoutConstraint.activate([ handleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                                          handleView.heightAnchor.constraint(equalToConstant: 30),
                                          handleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                          handleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor) ])
            contentView.bringSubviewToFront(handleView)
        }
    }
}

