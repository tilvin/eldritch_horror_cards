//
//  AuthView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 9/9/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol AuthViewDelegate: class {
	func loginButtonPressed()
	func signupButtonPressed()
}

enum AuthErrorType {
	case email, password, none
}

extension AuthView {
	
	struct Appearance {
		let errorColor: UIColor = UIColor.errorBorder
		let normalColor: UIColor = UIColor.mako
		let textFieldSideOffset: CGFloat = ScreenType.item(for: (.inch4, 50), (.inch5_5, 70), (.inch5_8, 70))
		let buttonSideOffset: CGFloat = ScreenType.item(for: (.inch4, 30), (.inch5_5, 50), (.inch5_8, 50))
		let avatarBottomSeparatorHeight: CGFloat = ScreenType.item(for: (.inch4, 30), (.inch5_5, 70), (.inch5_8, 70))
	}
}

class AuthView: BaseScrollView {
	
	//MARK: - Public variables
	
	var delegate: AuthViewDelegate?
	
	//MARK: - Private variables
	
	private let appearance = Appearance()
	
	//MARK: - Public lazy variables
	
	lazy var avatarView: AvatarView = {
		return AvatarView()
	}()
	
	lazy var emailTextField: UITextField = {
		return UITextField(placeholder: "auth.email".localized, textColor: .mako)
	}()
	
	lazy var passwordTextField: UITextField = {
		return UITextField(placeholder: "auth.password".localized, textColor: .mako)
	}()
	
	lazy var emailLineView: UIView = {
		let view = UIView()
		view.backgroundColor = .mako
		return view
	}()
	
	lazy var passwordLineView: UIView = {
		let view = UIView()
		view.backgroundColor = .mako
		return view
	}()
	
	lazy var emailStack: UIStackView = {
		createStackView(textField: emailTextField, view: emailLineView)
	}()
	
	lazy var passwordStack: UIStackView = {
		createStackView(textField: passwordTextField, view: passwordLineView)
	}()
	
	//MARK: - Private lazy variables
	
	private lazy var authBackgroundImageView: UIImageView = {
		return UIImageView(with: UIImage.authBackground, contentMode: .scaleToFill)
	}()
	
	private lazy var titleLabel: UILabel = {
		let view = UILabel(font: .bold32, textColor: .darkGreenBlue)
		view.numberOfLines = 2
		view.textAlignment = .center
		view.text = "Eldritch Horror\nCards"
		return view
	}()
	
	private lazy var loginButton: CustomButton = {
		let view = CustomButton(type: .darkGreenBlue)
		view.setTitle("auth.signin".localized, for: .normal)
		return view
	}()
	
	private lazy var signUpButton: UIButton = {
		let view = UIButton()
		view.titleLabel?.font = .regular12
		view.setTitle("auth.signup".localized, for: .normal)
		view.setTitleColor(.darkGreenBlue, for: .normal)
		return view
	}()

	//MARK: - Init
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		scrollView.backgroundColor = .clear
		addSubviews()
		makeConstraints()
		loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
		signUpButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func updateView(type: AuthErrorType) {
		switch type {
		case .email:
			emailLineView.backgroundColor = appearance.errorColor
			emailStack.shake()
		case .password:
			passwordLineView.backgroundColor = appearance.errorColor
			passwordStack.shake()
		case .none:
			emailLineView.backgroundColor = appearance.normalColor
			passwordLineView.backgroundColor = appearance.normalColor
		}
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		insertSubview(authBackgroundImageView, at: 0)
		addSeparatorView(height: 30)
		addToStackView(view: titleLabel, embed: true)
		addSeparatorView(height: 30)
		addToStackView(view: avatarView, embed: true)
		addSeparatorView(height: appearance.avatarBottomSeparatorHeight)
		addToStackView(view: emailStack, embed: true)
		addSeparatorView(height: 50)
		addToStackView(view: passwordStack, embed: true)
		addSeparatorView(height: 70)
		addToStackView(view: loginButton, embed: true)
		addSeparatorView(height: 30, expandable: true)
		addToStackView(view: signUpButton, embed: true)
		addSeparatorView(height: 10)
	}
	
	private func makeConstraints() {
		authBackgroundImageView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		avatarView.snp.removeConstraints()
		avatarView.snp.makeConstraints { (make) in
			make.width.height.equalTo(150)
			make.centerY.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
		
		emailLineView.snp.makeConstraints { (make) in
			make.height.equalTo(1)
		}
		
		passwordLineView.snp.makeConstraints { (make) in
			make.height.equalTo(1)
		}
		
		emailStack.snp.remakeConstraints { (make) in
			make.height.equalTo(40)
			make.left.right.equalToSuperview().inset(appearance.textFieldSideOffset)
			
		}
		
		passwordStack.snp.remakeConstraints { (make) in
			make.height.equalTo(40)
			make.left.right.equalToSuperview().inset(appearance.textFieldSideOffset)
		}
		
		loginButton.snp.remakeConstraints { (make) in
			make.left.right.equalToSuperview().inset(appearance.buttonSideOffset)
			make.height.equalTo(45)
		}

		signUpButton.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
		}
	}
	
	private func createStackView(textField: UITextField, view: UIView) -> UIStackView {
		let stackView = UIStackView()
		stackView.addArrangedSubview(textField)
		stackView.addArrangedSubview(view)
		stackView.axis = .vertical
		stackView.spacing = 3
		stackView.alignment = .fill
		stackView.distribution = .fill
		return stackView
	}
	
	//MARK: - Handlers
	
	@objc private func loginButtonPressed() {
		delegate?.loginButtonPressed()
	}
	
	@objc private func signupButtonPressed() {
		delegate?.signupButtonPressed()
	}
}
