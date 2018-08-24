//
//  EmbedSwipableViewCell.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 19..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class EmbedSwipableViewCell: UITableViewCell {

    var swipableCollectionView: HorizontallySwipableCollectionView = HorizontallySwipableCollectionView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        swipableCollectionView.backgroundColor = UIColor.white
        contentView.addSubview(swipableCollectionView)
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        swipableCollectionView.fillSuperview()
        super.updateConstraints()
    }

    func isLastCell(_ row: Int) -> Bool {
        return (row + 1) % swipableCollectionView.builder.cellCountByPage == 0
    }

}
