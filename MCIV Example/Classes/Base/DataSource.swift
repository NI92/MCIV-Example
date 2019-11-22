//
//  DataSource.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Foundation class for all children to contain table view/collection view data-to-cell manipulation & interaction.

import UIKit

protocol DataSourceConvertable {}
typealias ReuseIdentifier = String
typealias ConfigurationBlock = (DataSourceConvertable) -> ()

struct ElementConfigurator {
    let reuseIdentifier: ReuseIdentifier
    let configurationBlock: ConfigurationBlock?
}

class DataSource: NSObject {
    fileprivate(set) weak var tableView: UITableView? {
        didSet {
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
        }
    }
    
    fileprivate(set) weak var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.delegate = self
            self.collectionView?.dataSource = self
        }
    }
    
    required init(tableView: UITableView) {
        defer { self.tableView = tableView }
        super.init()
    }
    
    
    required init(collectionView: UICollectionView) {
        defer { self.collectionView = collectionView }
        super.init()
    }
    
    // MARK: For table view cells & collection view items
    func configurator(_ indexPath: IndexPath) -> ElementConfigurator {
        fatalError("You should ovveride method `configurator`")
    }
    
    // MARK: Collection view supplementary views
    func supplementaryConfigurator(_ kind: String, indexPath: IndexPath) -> ElementConfigurator {
        fatalError("You should ovveride method `supplementaryConfigurator`")
    }
    
    func rowAction(_ indexPath: IndexPath) { }
    
    func rowActionDeselect(_ indexPath: IndexPath) { }
}

// MARK: - Presets (override methods)
extension DataSource {
    @objc func numberOfSections() -> Int { return 1 }
    @objc func numberOfElementsInSection(_ section: Int) -> Int { return 0 }
}

// MARK: - Table view resets
extension DataSource {
    @objc func heightForRow(_ indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
}

// MARK: - Collection view presets
extension DataSource {
    @objc func sizeForItem(_ indexPath: IndexPath) -> CGSize { return self.collectionView?.bounds.size ?? CGSize.zero }
}

// MARK: - Table view data source & delegate
extension DataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfElementsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = self.configurator(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath)
        configurator.configurationBlock?(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowAction(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        rowActionDeselect(indexPath)
    }
}

// MARK: - Collection view
extension DataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfElementsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let configurator = self.configurator(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: configurator.reuseIdentifier, for: indexPath)
        configurator.configurationBlock?(cell)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryConfigurator = self.supplementaryConfigurator(kind, indexPath: indexPath)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: supplementaryConfigurator.reuseIdentifier,
                                                                   for: indexPath)
        supplementaryConfigurator.configurationBlock?(view)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeForItem(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.rowAction(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.rowActionDeselect(indexPath)
    }
}

extension UITableViewCell: DataSourceConvertable {}
extension UICollectionReusableView: DataSourceConvertable {}
