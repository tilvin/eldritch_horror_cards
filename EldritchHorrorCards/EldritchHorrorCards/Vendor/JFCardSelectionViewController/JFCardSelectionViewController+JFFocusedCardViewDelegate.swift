import UIKit

extension JFCardSelectionViewController: JFFocusedCardViewDelegate {
    
    func focusedCardViewDidSelectActionItemOne(_ focusedCardView: JFFocusedCardView) {
        guard let actionOne = focusedCardView.card.action else { return }
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            delegate?.cardSelectionViewController(self, didSelectCardAction: actionOne, forCardAtIndexPath: indexPath)
        }
        else {
            let indexPath = IndexPath(item: 0, section: 0)
            delegate?.cardSelectionViewController(self, didSelectCardAction: actionOne, forCardAtIndexPath: indexPath)
        }
    }
    
    func focusedCardViewDidSelectDetailAction(_ focusedCardView: JFFocusedCardView) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            delegate?.cardSelectionViewController(self, didSelectDetailActionForCardAtIndexPath: indexPath)
        }
        else {
            let indexPath = IndexPath(item: 0, section: 0)
            delegate?.cardSelectionViewController(self, didSelectDetailActionForCardAtIndexPath: indexPath)
        }
    }
    
}
