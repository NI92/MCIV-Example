//
//  CommonViewController.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommonViewController: UIViewController {
    fileprivate var constraintToBindKeyboard: NSLayoutConstraint?
    fileprivate var constant: CGFloat = 0.0
    
    // MARK: Defaults
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Constraints
extension CommonViewController {
    func bindConstraintToKeyboard(_ constraint: NSLayoutConstraint, constant: CGFloat = 0.0) {
        self.constraintToBindKeyboard = constraint
        self.constant = constant
        self.addKeyboardObservers()
    }
}

// MARK: - Notifications
extension CommonViewController {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let constraint = self.constraintToBindKeyboard {
            constraint.constant = keyboardSize.height + self.constant
            let time = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)
            UIView.animate(withDuration: time ?? 0.23, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let constraint = self.constraintToBindKeyboard {
            let time = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)
            constraint.constant = self.constant
            UIView.animate(withDuration: time ?? 0.23, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - Errors
extension CommonViewController {
    func handleError(_ error: NSError) {
        // TODO: Parse authorization errors! Such as, refresh token if error = 401 || 403.
        let message = error.userInfo["message"] as? String ?? "unknownError".localized
        self.showAlert(message: message)
    }
    
    func showAlert(title: String = "",
                   message: String,
                   buttons: [String] = [],
                   cancelButtonIndex: Int? = nil,
                   destructiveButtonIndex: Int? = nil,
                   handler: ((Int) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        //alertController.view.tintColor = UIColor.projectGreen
        if buttons.count > 0 {
            for i in 0..<buttons.count {
                let action = UIAlertAction(title: buttons[i], style: i == destructiveButtonIndex ? .destructive : (i == cancelButtonIndex ? .cancel : .default)) { _ in
                    handler?(i)
                }
                alertController.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - HUD
extension CommonViewController {
    func showHUD() {
        //SVProgressHUD.show()
    }
    
    func hideHUD() {
        //SVProgressHUD.dismiss()
    }
}
