//
//  Router.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Foundation class for helping navigation between view controllers.

import UIKit

protocol Router {
    var storyboard: UIStoryboard {get}
    var presenter: UIViewController? {get}
    
    init(presenter: UIViewController?)
}

extension Router {
    func show(_ viewController: UIViewController) {
        guard let presenter = self.presenter else {
            UIWindow.keyWindowTransitToViewController(viewController)
            return
        }
        presenter.firstParent().view.endEditing(true)
        presenter.show(viewController, sender: .none)
    }
    
    func set(_ viewController: UIViewController, animated: Bool = true) {
        if let navVC = self.presenter?.navigationController {
            self.presenter?.firstParent().view.endEditing(true)
            navVC.setViewControllers([viewController], animated: animated)
        } else {
            self.show(viewController)
        }
    }
    
    func presentModal(_ viewController: UIViewController, animated: Bool = true, completion: (() -> ())? = .none) {
        guard let presenter = presenter else {
            UIWindow.keyWindowTransitToViewController(viewController)
            return
        }
        presenter.present(viewController,
                          animated: animated,
                          completion: completion)
    }
    
    func presentChild(_ viewController: UIViewController, inViewController vc: UIViewController) {
        vc.addChild(viewController)
        viewController.willMove(toParent: vc)
        vc.view.addSubview(viewController.view)
        viewController.didMove(toParent: vc)
    }
    
}

// MARK: - View controller
extension UIViewController {
    func firstParent() -> UIViewController {
        if let parent = self.parent {
            return parent.firstParent()
        } else {
            return self
        }
    }
}

// MARK: - Window
public extension UIWindow {
    class func keyWindowTransitToViewController(_ viewController: UIViewController) {
        guard let firstWindow = UIApplication.shared.windows.first else { return }
        firstWindow.transitToViewController(viewController)
    }
    
    func transitToViewController(_ viewController: UIViewController) {
        let currentSubviews = subviews
        insertSubview(viewController.view, belowSubview: rootViewController!.view)
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.rootViewController = viewController },
                          completion: { finished in
                            currentSubviews.forEach({
                                if !($0 is UIImageView) {
                                    $0.removeFromSuperview()
                                }
                            })
        })
    }
}
