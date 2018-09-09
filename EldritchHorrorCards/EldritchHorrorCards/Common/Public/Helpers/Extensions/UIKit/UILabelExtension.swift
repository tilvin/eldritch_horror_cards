//
//  UILabelExtension.swift
//  Ebs
//
//  Created by Vitalii Poponov on 13.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension UILabel {

	convenience init(font: UIFont, textColor: UIColor) {
		self.init()
		self.font = font
		self.textColor = textColor
	}

	func setLineHeight(lineHeight: CGFloat) {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 1.0
		paragraphStyle.lineHeightMultiple = lineHeight
		paragraphStyle.alignment = self.textAlignment

		let attrString = NSMutableAttributedString(string: self.text!)
		attrString.addAttribute(NSAttributedStringKey.font, value: self.font, range: NSMakeRange(0, attrString.length))
		attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
		self.attributedText = attrString
	}

	func halfTextColorChange (fullText: String, changeText: String ) {
		let strNumber: NSString = fullText as NSString
		let range = (strNumber).range(of: changeText)
		let attribute = NSMutableAttributedString.init(string: fullText)
		attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
		self.attributedText = attribute
	}

	/// Метод задающий для UILabel текст, высоту строки и кернинг
	/// - Parameters:
	/// 	- text: текст для UILabel
	/// 	- lineHeight: высота строки текста
	/// 	- kerning: кернинг для текста
	public func add(text: String, lineHeight: CGFloat?, kerning: CGFloat? = nil, lineBreakingMode: NSLineBreakMode = NSLineBreakMode.byTruncatingTail) {
		let textAligment = self.textAlignment
		let sLineHeight = lineHeight ?? font.lineHeight
		let attributeString = NSMutableAttributedString(string: text)
		let style = NSMutableParagraphStyle()
		style.lineHeightMultiple = sLineHeight / font.lineHeight
		style.lineBreakMode = lineBreakingMode
		let offset = (sLineHeight - font.lineHeight) / 2
		attributeString.addAttribute(.baselineOffset, value: offset, range: NSMakeRange(0, text.count))
		attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
		if let kerning = kerning {
			attributeString.addAttribute(.kern, value: kerning, range: NSMakeRange(0, text.count))
		}
		self.attributedText = attributeString
		self.textAlignment = textAligment
	}
}
