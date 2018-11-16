//
//  BaseCollectionAdapter.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 11/15/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class BaseCollectionAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    internal var collectionView: UICollectionView?
    
    func registerCell(items: [String: Swift.AnyClass?]) {
        for (key, value) in items {
            collectionView?.register(value, forCellWithReuseIdentifier: key)
        }
    }
    
    func refresh() {
        collectionView?.reloadData()
    }
    
    func connect(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        refresh()
    }
    
    func disconnect() {
        self.collectionView?.delegate = nil
        self.collectionView?.dataSource = nil
        self.collectionView = nil
    }
    
    func cellBy(identifier: String, indexPath: IndexPath) -> BaseCollectionViewCell? {
        return collectionView?.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? BaseCollectionViewCell
    }
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        return ""
    }
    
    //MARK: - TableView Datasource adn Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = cellIdentifier(for: indexPath)
        return cellBy(identifier: identifier, indexPath: indexPath) ?? BaseCollectionViewCell()
    }
}

