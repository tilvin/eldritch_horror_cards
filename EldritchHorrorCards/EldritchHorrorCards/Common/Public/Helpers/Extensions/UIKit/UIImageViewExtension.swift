//
//  UIImageViewExtension.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import UIKit

extension UIImageView {
	
	convenience init(with image: UIImage, contentMode: UIViewContentMode = .scaleAspectFit) {
		self.init()
		self.image = image
		self.contentMode = contentMode
	}
}
