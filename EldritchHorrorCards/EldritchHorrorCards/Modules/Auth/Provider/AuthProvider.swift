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
	
	var login: String? { get set }
	var avatar: UIImage? { get set }
	var isTokenLoaded: Bool { get }
	var allFieldIsValid: Bool { get }
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void)
	func logout(error: String?)
	func clear()
	func load(with login: String, completion: @escaping (Bool) -> Void)
	@discardableResult func isValid(type: AuthTextViewType, text: String) -> Bool
}

final class AuthProvider: AuthProviderProtocol {
	
	struct Constants {
		static let avatarKey = "avatar_key"
		static let loginKey = "login_key"
	}
	
	var avatar: UIImage?
	var currentUser: User?
	var token: String {
		guard let user = currentUser else { return "" }
		return user.token
	}
	var login: String?
	var allFieldIsValid: Bool {
		return emailIsValid && passwordIsValid
	}
	
	//MARK: - Private
	
	private var configProvider = DI.providers.resolve(ConfigProviderProtocol.self)!
	private var userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	private var emailIsValid: Bool = false
	private var passwordIsValid: Bool = false
	
	//MARK: - Init
	
	init() {
		loadData()
	}
	
	//MARK: - Public
	
	var isTokenLoaded: Bool {
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
		guard let userLogin = currentUser?.login, let userToken = currentUser?.token else {
			completion(false)
			return
		}
		configProvider.login = userLogin
		configProvider.token = userToken
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
	
	func load(with loginUser: String, completion: @escaping (Bool) -> Void) {
		guard let path = Bundle.main.path(forResource: "users", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else { return }
		
		guard let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) else {
			completion(false)
			return
		}
		
		DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [User].self, json: json) { [weak self] (result) in
			guard let sSelf = self else { return }
			if let value = result {
				sSelf.currentUser = value.filter { $0.login == loginUser }.first
				if let userImageStringURL = sSelf.currentUser?.imageURL {
					UIImage.loadImage(with: userImageStringURL, completion: { (image) in
						sSelf.currentUser?.image = image
						if let imageData = UIImagePNGRepresentation(image) {
							sSelf.userDefaultsProvider.set(key: Constants.avatarKey, value: imageData)
						}
					})
				}
				completion(true)
			}
		}
	}
	
	@discardableResult
	func isValid(type: AuthTextViewType, text: String) -> Bool {
		switch type {
		case .email:
			let value = NSPredicate.emailValidator.evaluate(with: text)
			emailIsValid = value
			return emailIsValid
		case .password:
			let value = text.count >= 6
			passwordIsValid = value
			return passwordIsValid
		}
	}
	
	//MARK: - Private
	
	func loadData() {
		self.login = userDefaultsProvider.get(key: Constants.loginKey, type: String.self)
		if let data = userDefaultsProvider.get(key: Constants.avatarKey, type: Data.self),
			let image = UIImage(data: data) {
			self.avatar = image
		}
	}
}
