//
// Created by Andrey Torlopov on 8/12/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
	var session: URLSession { get }
}

class NetworkService: NetworkServiceProtocol {

	lazy var session: URLSession = {
		let session = URLSession(configuration: URLSessionConfiguration.default)
		return session
	}()
}
