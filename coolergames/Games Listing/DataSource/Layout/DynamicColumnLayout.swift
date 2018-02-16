//
//  DynamicColumnLayout.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit

class DynamicColumnLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        initVars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initVars()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initVars()
    }
    
    private func initVars() {
        minimumLineSpacing = 8
        minimumInteritemSpacing = 8
        scrollDirection = .vertical
        recalculateItemSize()
    }
    
    var columns: Int = 2 {
        didSet {
            recalculateItemSize()
        }
    }
    private func recalculateItemSize() {
        let contentSize = self.collectionViewContentSize
        let insets = self.collectionView?.contentInset ?? .zero
        let ratio = CGFloat(200.0/120.0)
        let availableWidth = contentSize.width - (insets.left + insets.right)
        let itemWidth = (availableWidth / CGFloat(columns)) - (minimumInteritemSpacing * CGFloat(columns - 1))
        let itemHeight = itemWidth * ratio
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}
