//
//  BaseCollectionViewCell.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 11/15/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var object: Any? {
        didSet {
            didSetObject(object: object)
        }
    }
    
    internal func didSetObject(object: Any?) {
    }
}
