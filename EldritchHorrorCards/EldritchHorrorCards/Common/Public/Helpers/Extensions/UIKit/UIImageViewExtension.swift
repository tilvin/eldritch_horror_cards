//
//  UIImageViewExtension.swift
//  Ebs
//
//  Created by Andrey Torlopov on 9/6/18.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension UIImageView {
	
	convenience init(with image: UIImage, contentMode: UIViewContentMode = .scaleAspectFit) {
		self.init()
		self.image = image
		self.contentMode = contentMode
	}
}
