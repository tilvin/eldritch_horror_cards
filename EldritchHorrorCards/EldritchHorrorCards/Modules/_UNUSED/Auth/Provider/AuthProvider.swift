//
//  AuthProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import RealmSwift

protocol AuthProviderProtocol {
	var currentUser: UserProtocol? { get set }
	var allFieldIsValid: Bool { get }
	
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void)
	func logout(error: String?)
	@discardableResult func isValid(type: AuthTextViewType, text: String) -> Bool
	func loadAvatar(login: String, completion: @escaping (UIImage?) -> Void)
}

final class AuthProvider: AuthProviderProtocol {
	var currentUser: UserProtocol?
	var allFieldIsValid: Bool {
		return emailIsValid && passwordIsValid
	}
	
	//MARK: - Private
	
	private var realm = try! Realm()
	private var emailIsValid: Bool = false
	private var passwordIsValid: Bool = false
	
	//MARK: - Init
	
	init() {
		let user = User()
		user.login = "Unknown user"
		user.token = UUID().uuidString
		user.userName = "Unknown user"
		user.imageURL = "https://www.fakepersongenerator.com/Face/male/male20171086711834930.jpg"
		user.image = .defaultAvatar
		currentUser = user
		
//		loadData()
	}
	
	//MARK: - Public
	
	var isTokenLoaded: Bool {
		guard let user = currentUser else { return false }
		return !user.token.isEmpty && !user.login.isEmpty
	}
	
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
		//TODO: отправка запроса на сервер и получение данных
		let  user = User()
		user.login = login
		user.token = UUID().uuidString
		user.userName = "Unknown user"
		user.imageURL = "https://www.fakepersongenerator.com/Face/male/male20171086711834930.jpg"
		
		UIImage.loadImageWith(url: user.imageURL) { (image) in
			debugPrint("avatar is loaded...")
			user.image = image
			completion(true)
		}
		currentUser = user
		let realmObj = try! Realm()
		try! realmObj.write {
			realmObj.add(user, update: true)
			debugPrint("realm writed, completion...")
		}
	}
	
	func logout(error: String?) {
		try! realm.write {
			currentUser = nil
			realm.delete(realm.objects(User.self))
			realm.delete(realm.objects(Game.self))
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
	
	func loadAvatar(login: String, completion: @escaping (UIImage?) -> Void) {
		//TODO: Загрузка аватара с сервера!
		
		let url = "https://www.fakepersongenerator.com/Face/female/female1021897675110.jpg"
		UIImage.loadImageWith(url: url) { (image) in
			completion(image)
		}
	}
	
	//MARK: - Private
	
	func loadData() {
		currentUser = realm.objects(User.self).first
	}
}
