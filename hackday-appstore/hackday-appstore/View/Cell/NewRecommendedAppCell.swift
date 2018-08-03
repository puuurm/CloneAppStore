//
//  NewRecommendedAppCell.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 19..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class NewRecommendedAppCell: EmbedSwipableViewCell, ConfigurableCell {

    typealias T = (app: App, status: String)

    private var cellModel: [(app: App, status: String)] = []
    private let cell = DownLoadAppCell.self

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        swipableCollectionView.register(self.cell, forCellWithReuseIdentifier: self.cell.identifier)
        swipableCollectionView.horizontallySwipableCollectionViewDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ cellModel: [T]) {
        self.cellModel = cellModel
        swipableCollectionView.builder = HorizontallySwipableCollectionViewBuilder(
            numberOfRow: cellModel.count,
            cells: [self.cell],
            cellCountByPage: 3
        )
    }

}

extension NewRecommendedAppCell: HorizontallySwipableCollectionViewDelegate {
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

class DownLoadAppCell: UICollectionViewCell {

    // [멘토] lazy 키워드 사용하도록 : 매번 호출할 때마다 새로 만들어서 보내기 때문에 불필요한 동작이 발생될 뿐아니라, 설정한 값이 초기화되기 때문에 오동작할 수 있음
    let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .darkText
        return label
    }()

    let appSimpleCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray
        return label
    }()

    lazy var labelStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.appNameLabel, self.appSimpleCommentLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.arrangedSubviews.forEach { $0.autoLayout }
        stackView.backgroundColor = UIColor.green
        return stackView
    }()


    let downloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(white: 0, alpha: 0.1)
        button.setTitleColor(.appStoreBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()

    let downloadButtonDeleteVersion: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.Icon.downloadapp, for: .normal)
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()

    private let separatorLineView: UIView = ViewMaker.createSeparatorLineView()

    var isSeparatorLineViewHide: Bool = false {
        willSet {
            separatorLineView.isHidden = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(model: (app: App, status: String)) {
        if model.status.isEmpty {
            downloadButtonDeleteVersion.isHidden = false
            downloadButton.isHidden = true
        } else {
            downloadButtonDeleteVersion.isHidden = true
            downloadButton.isHidden = false
            downloadButton.setTitle(model.status, for: .normal)
        }
        appImageView.image = model.app.resource?.appIcon()
        appNameLabel.text = model.app.info?.name
        appSimpleCommentLabel.text = model.app.info?.simpleComment

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.subviews.forEach { $0.autoLayout }
        NSLayoutConstraint.activate([
            appImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            appImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appImageView.heightAnchor.constraint(equalToConstant: 50) ,
            appImageView.widthAnchor.constraint(equalTo: appImageView.heightAnchor),

            labelStackView.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 10),
            labelStackView.centerYAnchor.constraint(equalTo: appImageView.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: downloadButton.leadingAnchor, constant: -10),

            separatorLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            separatorLineView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: downloadButton.trailingAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),

            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            downloadButton.centerYAnchor.constraint(equalTo: appImageView.centerYAnchor),

            downloadButtonDeleteVersion.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            downloadButtonDeleteVersion.centerYAnchor.constraint(equalTo: appImageView.centerYAnchor),
            downloadButtonDeleteVersion.heightAnchor.constraint(equalToConstant: 20),
            downloadButtonDeleteVersion.widthAnchor.constraint(equalTo: downloadButtonDeleteVersion.heightAnchor, multiplier: 1)
            ])
    }

    func initViews() {
        contentView.addSubview(appImageView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(downloadButton)
        contentView.addSubview(downloadButtonDeleteVersion)
        contentView.addSubview(separatorLineView)
    }

}


