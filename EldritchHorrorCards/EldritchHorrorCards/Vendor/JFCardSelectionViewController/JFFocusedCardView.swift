/*
* JFFocusedCardView
*
* Created by Jeremy Fox on 3/1/16.
* Copyright (c) 2016 Jeremy Fox. All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

import UIKit

protocol JFFocusedCardViewDelegate {
	func focusedCardViewDidSelectDetailAction(_ focusedCardView: JFFocusedCardView)
	func focusedCardViewDidSelectActionItemOne(_ focusedCardView: JFFocusedCardView)
}

class JFFocusedCardView: UIView {
	var card: CardPresentable!
	var delegate: JFFocusedCardViewDelegate?
	fileprivate var recognizer: UITapGestureRecognizer!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subTitleLabelOne: UILabel!
	@IBOutlet var subTitleLabelTwo: UILabel!
	@IBOutlet weak var actionOneButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 2
		imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
		imageView.layer.borderWidth = 0.5
		actionOneButton.isHidden = true
		recognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
		imageView.addGestureRecognizer(recognizer)
		imageView.isUserInteractionEnabled = true
	}
	
	func configureForCard(_ card: CardPresentable?) {
		guard let _card = card else {
			self.card = nil
			self.imageView.image = nil
			self.titleLabel.text = nil
			self.subTitleLabelOne.text = nil
			self.subTitleLabelTwo.text = nil
			return
		}
		
		self.card = _card
		if let _action = self.card.action {
			let title = _action.title
			actionOneButton.setTitle(title, for: UIControlState())
			actionOneButton.titleLabel?.adjustsFontSizeToFitWidth = true
			actionOneButton.titleLabel?.minimumScaleFactor = 0.5
			actionOneButton.isHidden = false
		}
		imageView.image = UIImage(named: self.card.imageURLString)
		titleLabel.text = self.card.nameText
		subTitleLabelOne.text = self.card.detailText
	}
	
	@IBAction func actionOneButtonAction(_ sender: AnyObject) {
		delegate?.focusedCardViewDidSelectActionItemOne(self)
	}
	
	@objc func tapAction() {
		delegate?.focusedCardViewDidSelectDetailAction(self)
	}
}
