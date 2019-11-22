//
//  BasicCollectionCell.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//

import UIKit
import Kingfisher

class BasicCollectionCell: UICollectionViewCell {
    /// *NOTE: Image is set to '.scaleAspectFill' in its respective xib file. This is to avoid dynamic cell resizing (don't have time to implement it - perhaps a TODO?)
    @IBOutlet fileprivate var imageView: UIImageView!
    
    func setup(model: ArtModel) {
        self.backgroundColor = .random
        if let firstImageModel = model.images.first, firstImageModel.baseImageURL.count > 0, let url = URL(string: firstImageModel.baseImageURL) {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url,
                                       placeholder: nil,
                                       options: [.transition(.fade(1))],
                                       progressBlock: nil) { [weak self] (result) in
                                        guard let self = self else { return }
                                        self.backgroundColor = .clear
            }
        } else {
            self.imageView.image = nil
        }
    }
}
