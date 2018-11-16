//
//  CollectionEmptyView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 11/15/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func showEmptyView(title: String?, at position: CollectionEmptyView.Position) {
        hideEmptyView()
        
        let view = CollectionEmptyView(position: position)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(title: title)
        self.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview().inset(self.frame.height)
            make.left.width.equalToSuperview()
        }
        setNeedsUpdateConstraints()
        bringSubview(toFront: view)
    }
    
    func hideEmptyView() {
        let emptyView = subviews.first { (view) -> Bool in
            return (view as? CollectionEmptyView) != nil
        }
        emptyView?.removeFromSuperview()
    }
}

class CollectionEmptyView: UIView {
    
    enum Position {
        case center
        case top(offset: CGFloat)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(font: .regular14, textColor: .gallery)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(position: Position = .center) {
        super.init(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        makeConstraints(position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints(position: Position) {
        switch position {
        case .center:
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.centerY.equalToSuperview()
            }
        case .top(let offset):
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(offset)
            }
        }
    }
    
    func set(title: String?) {
        titleLabel.add(text: title ?? "", lineHeight: DefaultAppearance.lineHeight)
    }
}
