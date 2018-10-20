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
	func loginButtonPressed(login: String, password: String)
	func signupButtonPressed()
	func validateActiveField(type: AuthTextViewType, text: String)
	
	func beginEditing(fieldType: AuthTextViewType, text: String)
	func endEditing(fieldType: AuthTextViewType, text: String)
	func valueChanged(fieldType: AuthTextViewType, text: String)
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
		let stackViewSpacingHorizontal: CGFloat = 10
		let stackViewSpacingVertical: CGFloat = 3
	}
}

final class AuthView: BaseScrollView {
	
	//MARK: - Public variables
	
	var delegate: AuthViewDelegate?
	
	//MARK: - Private variables
	
	private let appearance = Appearance()
	private var viewModel: AuthViewModel!
	
	//MARK: - Public lazy variables
	
	lazy var emailTextView: AuthTextView = {
		let view = AuthTextView(viewModel: AuthTextViewModel(type: .email))
		view.delegate = self
		return view
	}()
	
	lazy var passwordTextView: AuthTextView = {
		let view = AuthTextView(viewModel: AuthTextViewModel(type: .password))
		view.delegate = self
		return view
	}()
	
	//MARK: - Private lazy variables
	
	private lazy var avatarView: AvatarView = {
		return AvatarView()
	}()
	
	private lazy var signUpButton: UIButton = {
		let view = UIButton()
		view.titleLabel?.font = .regular12
		view.setTitle(String(.authSignup), for: .normal)
		view.setTitleColor(.darkGreenBlue, for: .normal)
		view.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
		return view
	}()
	
	private lazy var authBackgroundImageView: UIImageView = {
		return UIImageView(with: UIImage.authBackground, contentMode: .scaleToFill)
	}()
	
	private lazy var titleLabel: UILabel = {
		let view = UILabel(font: .bold32, textColor: .darkGreenBlue)
		view.numberOfLines = 2
		view.textAlignment = .center
		view.text = String(.authTitle)
		return view
	}()
	
	private lazy var loginButton: CustomButton = {
		let view = CustomButton(type: .darkGreenBlue)
		view.setTitle(String(.authSignin), for: .normal)
		view.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
		return view
	}()

	//MARK: - Init
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		viewModel = AuthViewModel()
		scrollView.backgroundColor = .clear
		emailTextView.update(viewModel: viewModel.item(type: .email))
		passwordTextView.update(viewModel: viewModel.item(type: .password))
		addSubviews()
		makeConstraints()
		emailTextView.becomeFirstResponder()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(textFieldType: AuthTextViewType, text: String, state: AuthTextViewState) {
		viewModel.update(itemType: textFieldType, value: text, state: state)
		switch textFieldType {
		case .email:
			emailTextView.update(viewModel: AuthTextViewModel(type: textFieldType, text: text, state: state))
		case .password:
			passwordTextView.update(viewModel: AuthTextViewModel(type: textFieldType, text: text, state: state))
		}
	}
	
	public func update(avatar: UIImage?) {
		avatarView.update(avatar: avatar)
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		insertSubview(authBackgroundImageView, at: 0)
		addSeparatorView(height: 30)
		addToStackView(view: titleLabel, embed: true)
		addSeparatorView(height: 30)
		addToStackView(view: avatarView, embed: true)
		addSeparatorView(height: appearance.avatarBottomSeparatorHeight)
		addToStackView(view: emailTextView, embed: true)
		addSeparatorView(height: 25)
		addToStackView(view: passwordTextView, embed: true)
		addSeparatorView(height: 25)
		addToStackView(view: loginButton, embed: true)
		addSeparatorView(expandable: true)
		addToStackView(view: signUpButton, embed: false)
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

		emailTextView.snp.remakeConstraints { (make) in
			make.left.right.equalToSuperview().inset(appearance.textFieldSideOffset)
			make.top.bottom.equalToSuperview()
		}
		
		passwordTextView.snp.remakeConstraints { (make) in
			make.left.right.equalToSuperview().inset(appearance.textFieldSideOffset)
			make.top.bottom.equalToSuperview()
		}
		
		loginButton.snp.remakeConstraints { (make) in
			make.left.right.equalToSuperview().inset(appearance.buttonSideOffset)
			make.height.equalTo(45)
			make.top.bottom.equalToSuperview()
		}
	}
	
	private func createStackView(textField: UITextField, view: UIView) -> UIStackView {
		let stackView = UIStackView()
		stackView.addArrangedSubview(textField)
		stackView.addArrangedSubview(view)
		stackView.axis = .vertical
		stackView.spacing = appearance.stackViewSpacingVertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		return stackView
	}
	
	//MARK: - Handlers
	
	@objc private func loginButtonPressed() {
		
		delegate?.loginButtonPressed(login: viewModel.item(type: .email).text, password: viewModel.item(type: .password).text)
	}
	
	@objc private func signupButtonPressed() {
		delegate?.signupButtonPressed()
	}
}

extension AuthView: AuthTextViewDelegate {
	
	func beginEditing(fieldType: AuthTextViewType, text: String) {
		delegate?.beginEditing(fieldType: fieldType, text: text)
	}
	
	func endEditing(fieldType: AuthTextViewType, text: String) {
		delegate?.endEditing(fieldType: fieldType, text: text)
	}
	
	func valueChanged(fieldType: AuthTextViewType, text: String) {
		delegate?.valueChanged(fieldType: fieldType, text: text)
	}
}
