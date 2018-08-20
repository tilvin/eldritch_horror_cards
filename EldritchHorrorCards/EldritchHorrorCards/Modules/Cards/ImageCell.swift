

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet private(set) var cardImageView: UIImageView!
    @IBOutlet private(set) var cardTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
		self.shadowOffset = CGPoint.zero
		self.shadowOpacity = 1
		self.shadowRadius = 4
		self.shadowColor = UIColor.darkGray
    }
}
