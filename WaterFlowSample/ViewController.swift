//
//  ViewController.swift
//  TestWaterfallsFlow
//
//  Created by MichaelMou on 15/7/23.
//  Copyright (c) 2015年 MichaelMou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cellIdentifier = "cellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let waterFlowLayout = MicWaterFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterFlowLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 150
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
}

