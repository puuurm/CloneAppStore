//
//  CategoryCell.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell, ConfigurableCell {

    typealias T = Category

    var tableView: UITableView
    var cellModel: [T] = []
    let cell = CategoryCell.self
    let numberOfItems: Int = 6

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews() {
        tableView.isScrollEnabled = false
        contentView.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(self.cell, forCellReuseIdentifier: self.cell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black

        self.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
    }

    func configure(_ cellodel: [Category]) {
        self.cellModel = cellodel
    }

    override func layoutSubviews() {
        tableView.fillSuperview()
    }
}

extension CategoryListCell: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: self.cell, for: indexPath)
        cell?.configure(categoryInfo: cellModel[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  bounds.height / CGFloat(numberOfItems)
    }

}

class CategoryCell: UITableViewCell {

    private let imageLeadingConstant: CGFloat = 20
    private let labelLeadingConstant: CGFloat = 20
    private let separatorLineView: UIView = ViewMaker.createSeparatorLineView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(categoryInfo: Category) {
        imageView?.image = UIImage(named: categoryInfo.categoryId!)
        textLabel?.text = categoryInfo.categoryName

    }

    func initViews() {
        separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        selectionStyle = .none
        textLabel?.textColor = .appStoreBlue
        textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        imageView?.contentMode = .scaleAspectFit
        contentView.addSubview(separatorLineView)
    }

    override func layoutSubviews() {
        guard let imageView = imageView, let textLabel = textLabel else { return }
        contentView.subviews.forEach { $0.autoLayout }
        object_setClass(imageView.layer, RoundedLayer.self)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imageLeadingConstant),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: labelLeadingConstant),
            textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            separatorLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLineView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor)
            ])
    }

    override func updateConstraints() {
        super.updateConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let opaqueBlack = UIColor.black.withAlphaComponent(0.2)
        backgroundColor = highlighted ? opaqueBlack : .white
    }

}

