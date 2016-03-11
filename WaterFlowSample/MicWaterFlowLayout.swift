//
//  MicWaterFlowLayout.swift
//  TestWaterfallsFlow
//
//  Created by MichaelMou on 15/7/23.
//  Copyright (c) 2015年 MichaelMou. All rights reserved.
//

import UIKit

class MicWaterFlowLayout: UICollectionViewFlowLayout {
    
//    列数, recommanding to set bigger than 1
    let numbersInLine = 3
    var widthOfItem:CGFloat {
        var width = UIScreen.mainScreen().bounds.width
        width -= self.sectionInset.left
        width -= self.sectionInset.right
        width -= CGFloat(self.numbersInLine - 1) * self.minimumInteritemSpacing
        return width / CGFloat(self.numbersInLine)
    }
    
    var getRandomHeight:CGFloat {
        return CGFloat(arc4random() % 300)
    }
    
//    生成n个伪随机高度
    lazy var heightsOfItem : [CGFloat] = {
       
        var heights = [CGFloat]()
        let collectionView:UICollectionView! = self.collectionView!
        for _ in 0..<collectionView.numberOfItemsInSection(0){
            heights.append(self.getRandomHeight)
        }
        
        return heights
    }()
    
    override func prepareLayout() {
        
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.minimumLineSpacing = 5
        self.minimumInteritemSpacing = 5
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributesArray = [UICollectionViewLayoutAttributes]()
        for i in 0..<self.collectionView!.numberOfSections(){
            let numberOfCellsInSection = self.collectionView!.numberOfItemsInSection(i)
            for j in 0..<numberOfCellsInSection {
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                if let attributes = self.layoutAttributesForItemAtIndexPath(indexPath){
                    if (CGRectIntersectsRect(rect, attributes.frame)) {
                        attributesArray.append(attributes)
                    }
                }
            }
        }
        return  attributesArray

    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItemAtIndexPath(indexPath){
            
            attributes.size = CGSizeMake(self.widthOfItem, self.heightsOfItem[indexPath.row])
            
            var y = self.sectionInset.top
            //        第几行
            let indexOfLine = indexPath.row / self.numbersInLine
            //        第几列
            let indexOfRow = indexPath.row % self.numbersInLine
            //        第一行前面没有Item，不用加前面的高度了
            if indexOfLine > 0 {
                //            第二行起，把所有列的前面的所有Item的高度和LineSpacing都加一次
                for currentLine in 1...indexOfLine{
                    let heightOfLastLine = self.heightsOfItem[(currentLine - 1) * self.numbersInLine + indexOfRow]
                    y += heightOfLastLine
                    y += self.minimumLineSpacing
                }
            }
            attributes.frame.origin.y = y
            
            //        因为宽度是根据inset和InteritemSpacing算出来的，所以这里直接x的值可直接算出来了
            var x = self.sectionInset.left
            x += CGFloat(indexOfRow) * self.widthOfItem
            x += CGFloat(indexOfRow) * self.minimumInteritemSpacing
            
            attributes.frame.origin.x = x
            
            return attributes
        }
        return nil
    }
    
    override func collectionViewContentSize() -> CGSize {
        var contentSize = CGSizeZero
        let numbersOfItem = self.collectionView!.numberOfItemsInSection(0)
        contentSize.width = self.collectionView!.bounds.width
        contentSize.height += self.sectionInset.top + self.sectionInset.bottom
    
        var heightsOfRow = [CGFloat](count: self.numbersInLine, repeatedValue: 0)
        for index in 0..<numbersOfItem{
        
            //        第几行
            let indexOfLine = index / self.numbersInLine
            //        第几列
            let indexOfRow = index % self.numbersInLine
            
            let heightOfCurrentLine = self.heightsOfItem[indexOfLine * self.numbersInLine + indexOfRow]
            heightsOfRow[indexOfRow] += heightOfCurrentLine + self.minimumLineSpacing

        }
        contentSize.height += heightsOfRow.maxElement()!
        contentSize.height -= self.minimumLineSpacing
        if contentSize.height < self.collectionView!.contentSize.height{
            contentSize.height = self.collectionView!.contentSize.height
        }
        return contentSize
    }
   
}
