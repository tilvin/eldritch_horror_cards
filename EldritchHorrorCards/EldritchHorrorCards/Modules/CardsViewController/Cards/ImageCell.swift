
import UIKit

class ImageCell: UICollectionViewCell {
	@IBOutlet private(set) var cardImageView: UIImageView!
	@IBOutlet private(set) var cardTypeLabel: UILabel!
	var cardType = ""
	
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
		
		var provider = DI.providers.resolve(ExpeditionDataProviderProtocol.self)!
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		provider.expeditionType = cardType
		provider.load(gameId: gameProvider.game.id, type: cardType ) {  (success) in
			if success {
				let controller = ExpeditionViewController()
				controller.modalTransitionStyle = .crossDissolve
				DI.providers.resolve(NavigatorProtocol.self)?.go(controller: controller, mode: .push)
			}
			else {
				print("error!")
			}
		}
	}
}
