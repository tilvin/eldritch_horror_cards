import UIKit

extension JFCardSelectionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        guard indexPath != previouslySelectedIndexPath else {
            shake()
            return
        }
        guard let card = dataSource?.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath) else {
            return
        }
        updateUIForCard(card, atIndexPath: indexPath)
        previouslySelectedIndexPath = indexPath
    }
    
}

extension JFCardSelectionViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _dataSource = dataSource else { return 0 }
        return _dataSource.numberOfCardsForCardSelectionViewController(self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JFCardSelectionCell.reuseIdentifier, for: indexPath) as? JFCardSelectionCell else {
            fatalError("Expected to display a `JFCardSelectionCell`.")
        }
        guard let _dataSource = dataSource else {
            return cell
        }
        let card = _dataSource.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath)
        cell.configureForCard(card, inScrollView: collectionView)
        if (collectionView.indexPathsForSelectedItems?.count ?? 0) == 0 && indexPath.section == 0 && indexPath.row == 0 && focusedView.card == nil && previouslySelectedIndexPath == nil {
            focusedView.configureForCard(card)
            previouslySelectedIndexPath = indexPath
        }
        
        return cell
    }
}
