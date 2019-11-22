//
//  AboutRouter.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  'About' module navigation router.

import UIKit

struct AboutRouter: Router {
    let storyboard: UIStoryboard = UIStoryboard(name: "About", bundle: nil)
    weak var presenter: UIViewController?
    
    func showAbout() {
        let vc = self.storyboard.instantiateViewController(withIdentifier: AboutViewController.identifier)
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical
        self.show(vc)
    }
    
    func setAbout() {
        let vc = self.storyboard.instantiateViewController(withIdentifier: AboutViewController.identifier)
        self.set(vc)
    }
}
