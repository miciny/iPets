//
//  MyCollectionViewLayout.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/16.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class MyCollectionViewLayout: UICollectionViewLayout {
    
    // 内容区域总大小，不是可见区域
    override var collectionViewContentSize: CGSize {
        
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        let height = Width/2
        
        return CGSize(width: width, height: height)
    }
    
    
    // 所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let sectionCount = self.collectionView?.numberOfSections
        
        for j in 0 ..< sectionCount! {
            let cellCount = self.collectionView!.numberOfItems(inSection: j)
            for i in 0 ..< cellCount {
                let indexPath = IndexPath(item: i, section: j)
                let attributes = self.layoutAttributesForItem(at: indexPath)
                attributesArray.append(attributes!)
            }
        }
        return attributesArray
    }
    
    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            //当前单元格布局属性
            let attribute =  UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            //单元格边长
            let largeCellSide = collectionViewContentSize.width / 2
            let smallCellSide = collectionViewContentSize.width / 4
            
            if indexPath.section == 0{
                    attribute.frame = CGRect(x: smallCellSide*CGFloat(indexPath.item%4), y: smallCellSide*CGFloat(indexPath.item/4),
                                         width: smallCellSide,
                                         height: smallCellSide)

            }else{
                if (indexPath.item % 5 == 0) {
                    attribute.frame = CGRect(x: 0, y: 0,
                                             width: largeCellSide,
                                             height: largeCellSide)
                } else if (indexPath.item % 5 == 1) {
                    attribute.frame = CGRect(x: largeCellSide, y: 0,
                                             width: smallCellSide,
                                             height: smallCellSide)
                } else if (indexPath.item % 5 == 2) {
                    attribute.frame = CGRect(x: largeCellSide + smallCellSide, y: 0,
                                             width: smallCellSide,
                                             height: smallCellSide)
                } else if (indexPath.item % 5 == 3) {
                    attribute.frame = CGRect(x: largeCellSide, y: smallCellSide,
                                             width: smallCellSide,
                                             height: smallCellSide )
                } else if (indexPath.item % 5 == 4) {
                    attribute.frame = CGRect(x: largeCellSide + smallCellSide, y:  smallCellSide,
                                             width: smallCellSide,
                                             height: smallCellSide)
                }

            }
            
            return attribute
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute =  UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.size = CGSize(width: Width, height: 200)
        return attribute
    }
}
