//
//  CollectionCellConfiguration.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 11/15/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

protocol CollectionCellConfigurationProtocol {
    var identifier: String {get set}
    var size: CGSize {get set}
    func prepare(cell: BaseCollectionViewCell, indexPath: IndexPath)
    func didSelect(cell: BaseCollectionViewCell, indexPath: IndexPath)
}

class CollectionCellConfiguration<T>: CollectionCellConfigurationProtocol where T: BaseCollectionViewCell {
    
    internal var instance: Swift.AnyClass?
    var identifier: String
    var size: CGSize = UICollectionViewFlowLayoutAutomaticSize
    var configurationBlock: ((T, IndexPath) -> Void)?
    var actionBlock: ((T, IndexPath) -> Void)?
    
    init(instance: T.Type, size: CGSize = UICollectionViewFlowLayoutAutomaticSize, configureBlock: ((T, IndexPath) -> Void)?, actionBlock: ((T, IndexPath) -> Void)? ) {
        self.identifier = String(describing: instance)
        self.instance = instance
        self.configurationBlock = configureBlock
        self.actionBlock = actionBlock
        self.size = size
    }
    
    init(_ identifier: String, instance: T.Type, size: CGSize = UICollectionViewFlowLayoutAutomaticSize, configureBlock: ((T, IndexPath) -> Void)?, actionBlock: ((T, IndexPath) -> Void)?) {
        self.identifier = identifier
        self.instance = instance
        self.configurationBlock = configureBlock
        self.actionBlock = actionBlock
        self.size = size
    }
    
    func prepare(cell: BaseCollectionViewCell, indexPath: IndexPath) {
        if let action = configurationBlock, let cell = cell as? T {
            action(cell, indexPath)
        }
    }
    
    func didSelect(cell: BaseCollectionViewCell, indexPath: IndexPath) {
        if let action = actionBlock, let cell = cell as? T {
            action(cell, indexPath)
        }
    }
}
