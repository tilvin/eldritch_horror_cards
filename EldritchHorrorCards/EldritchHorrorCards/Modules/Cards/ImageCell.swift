
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
        
        // Action at tap on image
        cardImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped)) // self action
        cardImageView.addGestureRecognizer(tapRecognizer)
        
    }
    
    // TODO: - transition to this cell controller
    // Create
    @objc func imageTapped(sender: UIImageView) {
        let cards = CardViewController()
        
        // not working
        /* if cards.cardsTypes[0] == cards.cardType.portals {
            print("1")
        } else if cards.cardsTypes[1] == cards.cardType.cities {
            print("2")
        } else if cards.cardsTypes[2] == cards.cardType.expeditions {
            print("3")
        } else {
            fatalError("Unexpected value on ImageCell.swift 31*")
        } */
    }
}
