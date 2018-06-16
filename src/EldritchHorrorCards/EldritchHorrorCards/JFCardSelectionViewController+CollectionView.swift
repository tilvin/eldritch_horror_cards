/*
* JFCardSelectionViewController
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

extension JFCardSelectionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
