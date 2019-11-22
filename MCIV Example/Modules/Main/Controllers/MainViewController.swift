//
//  MainViewController.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  An intermediary element that simply connects data sources with their respective UI elements. Part of the 'Main' module.

import UIKit
import SVProgressHUD

class MainViewController: CommonViewController {
    @IBOutlet fileprivate var collectionView: UICollectionView!
    fileprivate lazy var presentationModel: MainPresentationModel = {
        let model = MainPresentationModel(errorHandler: { [weak self] (error) in
            guard let self = self else { return }
            self.handleError(error)
        })
        model.loadingHandler = { [weak self] in guard let self = self else { return }; $0 ? self.showHUD() : self.hideHUD() }
        return model
    }()
    fileprivate lazy var dataSource: MainDataSource = {
        let dataSource = MainDataSource(collectionView: self.collectionView)
        // Actions
        dataSource.didTapItemIndex = { [weak self] index in
            guard let self = self else { return }
            self.handleTappedIndex(index)
        }
        return dataSource
    }()
    fileprivate var tappedIndex: Int?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
}

// MARK: - Actions (setup)
extension MainViewController {
    fileprivate func setup() {
        self.setupNavBar()
        self.setupCollectionView()
        self.getData()
    }
    
    fileprivate func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "about".localized.uppercased(), style: .plain, target: self, action: #selector(handleAboutButton))
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "BasicCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BasicCollectionCell")
    }
}

// MARK: - Actions (debug)
extension MainViewController {
    fileprivate func debugPrint(model: ArtListModel, seconds: Double? = nil) {
        print("-------------------------------")
        if let secs = seconds {
            print("Retrieval time: \(secs) secs")
        }
        print("Total records count: \(model.info.totalRecords)")
        print("Current records count: \(model.records.count)")
    }
}

// MARK: - Actions (handlers)
extension MainViewController {
    fileprivate func handleTappedIndex(_ index: Int) {
        guard let artList = self.dataSource.artList, index < artList.records.count else { return }
        self.tappedIndex = index
        self.performSegue(withIdentifier: "SegueMainDetail", sender: nil)
    }
    
    @objc fileprivate func handleAboutButton() {
        AboutRouter(presenter: self).showAbout()
    }
}

// MARK: - Actions (network)
extension MainViewController {
    fileprivate func getData() {
        // Background thread (data & network calls!)
        Processor.shared.backgroundThread { [weak self] in
            guard let self = self else { return }
            // Measure time
            let start = Date()
            self.presentationModel.refreshHandler = { model in
                // Network call result
                let end = Date()
                let seconds: Double = end.timeIntervalSince(start)
                // Main thread (UI!)
                Processor.shared.mainThread {
                    self.debugPrint(model: model, seconds: seconds)
                    self.dataSource.refresh(artList: model)
                }
            }
            self.presentationModel.getMuseumData()
        }
    }
}

// MARK: - Actions (navigation)
extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueMainDetail" {
            guard let vc = segue.destination as? MainDetailViewController, let artList = self.dataSource.artList, let index = self.tappedIndex else { return }
            vc.artModel = artList.records[index]
        }
    }
}
