//
//  NetworkRoutePath.swift
//  Ebs
//
//  Created by Vitalii Poponov on 11.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

enum NetworkRoutePath {
	
	case dumpFileInit
	
	var path: String {
		switch self {
		case .dumpFileInit:
			return "api/v2/dump-file"
		}
	}
}
