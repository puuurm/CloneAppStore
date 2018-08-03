//
//  RecommendedAppCell.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class RecommendedAppCell: EmbedSwipableViewCell, ConfigurableCell {

    typealias T = (recommendedAppInfo: RecommendedApp , app: App)
    private let cell = RecommendedAppDetailCell.self
    private var model: [T] = []

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        swipableCollectionView.register(self.cell, forCellWithReuseIdentifier: cell.identifier)
        swipableCollectionView.horizontallySwipableCollectionViewDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ cellModel: [(recommendedAppInfo: RecommendedApp, app: App)]) {
        self.model = cellModel
        swipableCollectionView.builder = HorizontallySwipableCollectionViewBuilder(
            numberOfRow: self.model.count,
            cells: [self.cell],
            cellCountByPage: 1
        )
    }

}

extension RecommendedAppCell: HorizontallySwipableCollectionViewDelegate {
    func horizontallySwipableCollectionView(_ collectionView: HorizontallySwipableCollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

    func horizontallySwipableCollectionView(_ collectionView: HorizontallySwipableCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: self.cell, for: indexPath)
        cell?.configure(model: model[indexPath.row])
        return cell ?? UICollectionViewCell()
    }

}

class RecommendedAppDetailCell: UICollectionViewCell {

    private var containerStackView: UIStackView?

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .appStoreBlue
        return label
    }()

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkText
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()

    private let separatorLineView: UIView = ViewMaker.createSeparatorLineView()
    private let appImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    func configure(model: (recommendedAppInfo: RecommendedApp , app: App)) {
        subTitleLabel.text = model.recommendedAppInfo.subTitle
        appNameLabel.text = model.app.info?.name
        descriptionLabel.text = model.recommendedAppInfo.description
        appImageView.image = UIImage(named: model.recommendedAppInfo.bgImg!)
    }

    // [멘토] layoutSubviews보다는 updateConstraints에 constraint를 설정. 이유는 공부하도록
    override func layoutSubviews() {
        super.layoutSubviews()
        // [멘토] appImageView.layer.cornerRadius로 접근이 가능한데, 굳이 이렇게 사용한 이유는?
        object_setClass(appImageView.layer, RoundedLayer.self)
        containerStackView!.fillSuperview(Constant(leading: 5, trailing: 0, top: 5, botton: 0))
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // [멘토] UI 구현에 stack view를 사용한 것은 좋은 아이디어로 보이지만, 각 서브뷰 사이의 간격이 다르기 때문에 사용에 대해서는 한번쯤 고려해봤어야 했을 것으로 보임
    private func initViews() {
        containerStackView = UIStackView(arrangedSubviews: [separatorLineView, subTitleLabel, appNameLabel, descriptionLabel, appImageView])
        containerStackView?.axis = .vertical
        containerStackView?.distribution = .fill
        containerStackView?.spacing = 3
        contentView.addSubview(containerStackView!)
    }
}
