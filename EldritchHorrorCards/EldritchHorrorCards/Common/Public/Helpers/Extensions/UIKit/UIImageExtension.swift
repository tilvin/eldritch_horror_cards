//
//  UIImageExtension.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 10/20/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UIImage {
	
	static func loadImage(with url: String, completion: @escaping (UIImage) -> Void) {
		DispatchQueue.global(qos: .default).async {
			guard let imageUrl = URL(string: url),
				let imageData = try? Data(contentsOf: imageUrl),
				let image = UIImage(data: imageData) else { return }
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}
}
