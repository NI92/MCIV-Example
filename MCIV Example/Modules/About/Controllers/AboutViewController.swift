//
//  AboutViewController.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  A simple module for displaying some "about" text. Meant to demonstrate how to jump between modules.

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet fileprivate var aboutLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutLabel.text = "aboutDescription".localized.capitalized
    }
}
