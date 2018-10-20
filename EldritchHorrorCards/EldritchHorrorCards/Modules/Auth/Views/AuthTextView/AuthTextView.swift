//
//  AuthTextView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 10/20/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

enum AuthTextViewState {
	case normal, active, error
}

protocol AuthTextViewDelegate: class {
	func beginEditing(fieldType: AuthTextViewType, text: String)
	func endEditing(fieldType: AuthTextViewType, text: String)
	func valueChanged(fieldType: AuthTextViewType, text: String)
}

extension AuthTextView {
	struct Appearance {
		let stackViewSpacingHorizontal: CGFloat = 10
		let stackViewSpacingVertical: CGFloat = 5
	}
}

final class AuthTextView: UIView {
	weak var delegate: AuthTextViewDelegate?
	private let appearance = Appearance()
	var type: AuthTextViewType!
	
	//MARK: -
	
	lazy var textField: UITextField = {
		let view = UITextField(placeholder: "", textColor: .mako)
		view.delegate = self
		view.addTarget(self, action: #selector(textChanged), for: .editingChanged)
		view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		view.setContentHuggingPriority(.defaultLow, for: .horizontal)
		return view
	}()
	
	lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentHuggingPriority(.required, for: .vertical)
		return view
	}()
	
	lazy var stackView: UIStackView = {
		var view = UIStackView()
		view.alignment = .center
		view.distribution = .fill
		view.spacing = appearance.stackViewSpacingHorizontal
		return view
	}()
	
	lazy var underLineView: UIView = {
		return UIView(backgroundColor: .mako)
	}()
	
	//MARK: - Init
	
	init(viewModel: AuthTextViewModel) {
		super.init(frame: CGRect.zero)
		addSubviews()
		makeConstraints()
		update(viewModel: viewModel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(viewModel: AuthTextViewModel) {
		textField.placeholder = viewModel.placeholder
		type = viewModel.type
		imageView.image = viewModel.image
		textField.isSecureTextEntry = viewModel.isSecureTextField
		textField.text = viewModel.text
		switch viewModel.state {
		case .active:
			underLineView.backgroundColor = .mako
		case .normal:
			underLineView.backgroundColor = .gallery
		case .error:
			underLineView.backgroundColor = .errorBorder
			textField.shake()
		}
		
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		stackView.addArrangedSubview(imageView)
		stackView.addArrangedSubview(textField)
		addSubview(stackView)
		addSubview(underLineView)
	}
	
	private func makeConstraints() {
		stackView.snp.makeConstraints { (make) in
			make.left.top.right.equalToSuperview()
		}
		
		//FIXME: костыль! Надо это убрать и исправить настройки imageView
		// надо картинку нормально нарисовать. тогда не будет растягиваний и багов
		imageView.snp.makeConstraints { (make) in
			make.height.width.equalTo(30)
		}
		
		underLineView.snp.makeConstraints { (make) in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(DefaultAppearance.lineHeight)
			make.top.equalTo(stackView.snp.bottom).offset(appearance.stackViewSpacingVertical)
		}
	}
	
	//MARK: - Handlers
	
	@objc
	private func textChanged() {
		delegate?.valueChanged(fieldType: self.type, text: textField.text ?? "")
	}
}

extension AuthTextView: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		delegate?.beginEditing(fieldType: self.type, text: textField.text ?? "")
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		delegate?.endEditing(fieldType: self.type, text: textField.text ?? "")
	}
}
