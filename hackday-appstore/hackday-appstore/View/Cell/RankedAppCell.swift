//
//  RankedCategoryCell.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class RankedAppCell: EmbedSwipableViewCell, ConfigurableCell {

    typealias T = (app: App, status: String)

    private var cellModel: [(app: App, status: String)] = []
    private let cell = RankedDownLoadAppCell.self

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        swipableCollectionView.register(self.cell, forCellWithReuseIdentifier: self.cell.identifier)
        swipableCollectionView.horizontallySwipableCollectionViewDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ cellModel: [(app: App, status: String)]) {
        self.cellModel = cellModel
        swipableCollectionView.builder = HorizontallySwipableCollectionViewBuilder(
            numberOfRow: cellModel.count,
            cells: [self.cell],
            cellCountByPage: 3
        )
    }

}

extension RankedAppCell: HorizontallySwipableCollectionViewDelegate {
    func horizontallySwipableCollectionView(_ collectionView: HorizontallySwipableCollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

    func horizontallySwipableCollectionView(_ collectionView: HorizontallySwipableCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: self.cell, for: indexPath)
        cell?.configure(model: cellModel[indexPath.row])
        if isLastCell(indexPath.row) {
            cell?.isSeparatorLineViewHide = true
        } else {
            cell?.isSeparatorLineViewHide = false
        }
        return cell ?? UICollectionViewCell()
    }

}

class RankedDownLoadAppCell: DownLoadAppCell {

    private var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .darkText
        label.autoLayout
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func configure(model: (app: App, status: String)) {
        super.configure(model: model)
        rankLabel.text = model.app.info?.rank
    }

    override func updateConstraints() {
        NSLayoutConstraint.deactivate(labelStackView.constraints)
        NSLayoutConstraint.deactivate(appImageView.constraints)
        
        NSLayoutConstraint.activate([
            appImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            appImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appImageView.heightAnchor.constraint(equalToConstant: 50) ,
            appImageView.widthAnchor.constraint(equalTo: appImageView.heightAnchor),
            
            rankLabel.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 10),
            rankLabel.topAnchor.constraint(equalTo: appImageView.topAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 25),
            
            
            appNameLabel.topAnchor.constraint(equalTo: rankLabel.topAnchor),
            appNameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor),
            appNameLabel.trailingAnchor.constraint(equalTo: downloadButton.leadingAnchor, constant: -10),
            appSimpleCommentLabel.trailingAnchor.constraint(equalTo: appNameLabel.trailingAnchor),
            appSimpleCommentLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 3),
            appSimpleCommentLabel.leadingAnchor.constraint(equalTo: appNameLabel.leadingAnchor)
            
            ])
        super.updateConstraints()

    }

    override func initViews() {
        super.initViews()
        contentView.addSubview(rankLabel)
    }

}

