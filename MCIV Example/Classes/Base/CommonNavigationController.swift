//
//  CommonNavigationController.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//

import UIKit

struct NavigationBarOptions {
    let tintColor: UIColor
    let titleColor: UIColor
    
    static var defaultOptions: NavigationBarOptions {
        return NavigationBarOptions(tintColor: .black, titleColor: .black)
    }
}

class CommonNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
}

extension UINavigationController {
    func setup(_ options: NavigationBarOptions = NavigationBarOptions.defaultOptions) {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = options.tintColor
        self.setTitleColor(options.titleColor)
    }
    
    func setTitleColor(_ color: UIColor) {
        //self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color]
        //self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
    }
}
