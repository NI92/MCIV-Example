//
//  MainDataSource.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Handles presenting data into a collection view or a table view depending on data source init style. A single access point for either presentation model. BUT can NOT present with both simultaneously from here!

import UIKit

class MainDataSource: DataSource {
    var artList: ArtListModel?
    // Pass data back to the view controller
    var didTapItemIndex: ((_ index: Int)->Void)?
    
    // MARK: Memory
    deinit {
        self.didTapItemIndex = nil
        self.artList = nil
    }
    
    // MARK: Data source
    override func configurator(_ indexPath: IndexPath) -> ElementConfigurator {
        let identifier = "BasicCollectionCell"
        return ElementConfigurator(reuseIdentifier: identifier) { [unowned self] reusableCell in
            guard let cell = reusableCell as? BasicCollectionCell, let artList = self.artList else { return }
            cell.setup(model: artList.records[indexPath.row])
        }
    }
    
    override func numberOfElementsInSection(_ section: Int) -> Int {
        guard let artList = self.artList else { return 0 }
        return artList.records.count
    }
    
//    override func heightForRow(_ indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    override func sizeForItem(_ indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 100, height: 100)
        guard let collectionView = self.collectionView else { return .zero }
        let totalSize = collectionView.bounds.size
        let cellCountPerRow: CGFloat = 3
        let minSpacingOffset: CGFloat = 1
        let side = (totalSize.width/cellCountPerRow)-minSpacingOffset
        return CGSize(width: side, height: side)
    }
    
    override func rowAction(_ indexPath: IndexPath) {
        self.collectionView?.deselectItem(at: indexPath, animated: false)
        self.didTapItemIndex?(indexPath.row)
    }
    
    // MARK: Reload
    func refresh(artList: ArtListModel) {
        self.artList = artList
        self.collectionView?.reloadData()
    }
}
