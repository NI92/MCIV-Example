//
//  MainDetailViewController.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Handles presenting data on a single art piece.

import UIKit
import Kingfisher

class MainDetailViewController: CommonViewController {
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var aboutLabel: UILabel!
    @IBOutlet fileprivate var descriptionLabel: UILabel!
    var artModel: ArtModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Memory
    deinit {
        self.artModel = nil
    }
}

// MARK: - Actions (setup)
extension MainDetailViewController {
    fileprivate func setup() {
        guard let model = self.artModel else { self.close(); return }
        self.title = model.title
        self.setupImageView(model)
        self.setupLabels(model)
    }
    
    fileprivate func setupImageView(_ model: ArtModel) {
        if model.images.first == nil {
            self.showAlert(message: "noImagesAvailable".localized)
        }
        guard let firstImageModel = model.images.first,
            firstImageModel.baseImageURL.count > 0,
            let url = URL(string: firstImageModel.baseImageURL) else { self.close(); return }
        self.imageView.image = UIImage()
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: url,
                                   placeholder: nil,
                                   options: [.transition(.fade(1))],
                                   progressBlock: nil) { [weak self] (result) in
                                    guard let self = self else { return }
                                    self.imageView.backgroundColor = .clear
        }
    }
    
    fileprivate func setupLabels(_ model: ArtModel) {
        self.aboutLabel.text = ""
        self.descriptionLabel.text = ""
        self.aboutLabel.text = model.dated
        if let culture = model.culture {
            self.aboutLabel.text! += " " + culture
        }
        if let description = model.description {
            self.descriptionLabel.text = description
        }
    }
}

// MARK: - Actions (handlers)
extension MainDetailViewController {
    fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
