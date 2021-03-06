//
//  ProgressView.swift
//
// Created by Andrey Torlopov on 9/4/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//


import UIKit

final class LoaderView: UIView {

	//MARK: - Lazy variables

	lazy var spinner: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		view.color = .gray
		view.startAnimating()
		view.hidesWhenStopped = true
		return view
	}()

	//MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addSubviews()
		makeConstraints()
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(spinner)
	}
	
	private func makeConstraints() {
		spinner.snp.makeConstraints { (make) in
			make.center.equalTo(self)
		}
	}
}
