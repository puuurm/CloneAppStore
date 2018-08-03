//
//  ScrolledView.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 18..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

protocol HorizontallySwipableCollectionViewDelegate: class {
    func horizontallySwipableCollectionView(_ collectionView: HorizontallySwipableCollectionView, didDeselectItemAt indexPath: IndexPath)
    func horizontallySwipableCollectionView(_ collectionView: HorizontallySwipableCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

struct HorizontallySwipableCollectionViewBuilder {
    var numberOfRow: Int
    var cells: [Swift.AnyClass?]
    var cellCountByPage: Int
}

class HorizontallySwipableCollectionView: UICollectionView {

    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }

    var horizontallySwipableCollectionViewDelegate: HorizontallySwipableCollectionViewDelegate?
    
    var builder = HorizontallySwipableCollectionViewBuilder(numberOfRow: 0, cells: [], cellCountByPage: 0) {
        didSet {
            contentSize = CGSize(width: (bounds.size.width * CGFloat(builder.numberOfRow / builder.cellCountByPage)), height: bounds.size.height)
            reloadData()
        }
    }

    convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        self.init(frame: frame, collectionViewLayout: layout)
        isPagingEnabled = true
    }

    override private init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {

        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


extension HorizontallySwipableCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard horizontallySwipableCollectionViewDelegate != nil else {
            return UICollectionViewCell()
        }

        return horizontallySwipableCollectionViewDelegate!.horizontallySwipableCollectionView(self, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard horizontallySwipableCollectionViewDelegate != nil else {
            return
        }

        horizontallySwipableCollectionViewDelegate!.horizontallySwipableCollectionView(self, didDeselectItemAt: indexPath)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return builder.numberOfRow
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width - 24, height: frame.size.height/CGFloat(self.builder.cellCountByPage))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 12, 0, 12)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {

        func indexPathOfNextCell() -> IndexPath? {

            var currentCellOffset = contentOffset
            currentCellOffset.x += frame.size.width / 2

            return indexPathForItem(at: currentCellOffset)
        }

        if scrollView is UICollectionView, let indexPath = indexPathOfNextCell() {
            scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
