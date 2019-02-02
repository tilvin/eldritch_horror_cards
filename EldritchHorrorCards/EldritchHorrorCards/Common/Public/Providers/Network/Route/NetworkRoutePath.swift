//
//  NetworkRoutePath.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
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
