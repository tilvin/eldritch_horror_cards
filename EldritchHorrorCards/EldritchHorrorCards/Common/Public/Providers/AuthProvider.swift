//
//  AuthProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

protocol AuthProviderProtocol {
	var currentUser: User? { get set }
	var token: String { get }

	func loadToken() -> Bool
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void)
	func logout(error: String?)
	func clear()
	func load(with login: String, completion: @escaping (Bool) -> Void)
}

class AuthProvider: AuthProviderProtocol {
	private var configProvider = DI.providers.resolve(ConfigProviderProtocol.self)!
	var currentUser: User?

	var token: String {
		guard let user = currentUser else { return "" }
		return user.token
	}

	func loadToken() -> Bool {
		guard !configProvider.token.isEmpty else { return false }
		return !configProvider.login.isEmpty && !configProvider.token.isEmpty
	}
	
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
		guard !login.isEmpty, !password.isEmpty else {
			completion(false)
			return
		}
		
		//TODO: Переделать на загрузку данных с сети
//		let session: URLSession = DI.providers.resolve(NetworkServiceProtocol.self)!.session
//		let task = session.dataTask(with: APIRequest.login(login: login, password: password).request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
// распаковываем данные, парсим и записываем в configProvider
//		}
//		task.resume()
//		configProvider.login = userLogin
//		configProvider.token = userToken
		configProvider.save { (success) in
			if !success { print("Can't save login and token!") }
		}
		completion(true)
	}
	
	func logout(error: String?) {
		clear()
	}
	
	func clear() {
		configProvider.token = ""
		configProvider.login = ""
		configProvider.save(completion: nil)
	}
	
	private func loadImage(imageURL:String, completion: @escaping (UIImage) -> ()) {
		DispatchQueue.global(qos: .default).async {
			guard let imageUrl = URL(string: imageURL),
				let imageData = try? Data(contentsOf: imageUrl),
				let image = UIImage(data: imageData) else { return }
			UserDefaults.standard.set(imageData, forKey: "avatar")
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}
	
	func load(with loginUser: String, completion: @escaping (Bool) -> Void) {
		guard let path = Bundle.main.path(forResource: "users", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else { return }
		
		guard let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) else {
			completion(false)
			return
		}
				
		DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [User].self, json: json) { [weak self] (result) in
			if let value = result {
				self?.currentUser = value.filter { $0.login == loginUser }.first
				if let userImageURL = self?.currentUser?.imageURL {
					self?.loadImage(imageURL: userImageURL) { [weak self] (image) in
						self?.currentUser?.image = image
					}
				}
				completion(true)
			}
		}
	}
}
