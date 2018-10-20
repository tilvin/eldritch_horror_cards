//
//  NSPredicateExtension.swift
//  Ebs
//
//  Created by Andrey Torlopov on 10/7/18.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

extension NSPredicate {
	
	static var emailValidator: NSPredicate {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegEx)
	}
}
