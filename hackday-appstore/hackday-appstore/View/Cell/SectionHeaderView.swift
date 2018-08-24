//
//  SectionHeaderView.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.autoLayout
        return label
    }()

    private let showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.autoLayout
        return button
    }()

    private let separatorLineView: UIView = ViewMaker.createSeparatorLineView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(separatorLineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(showAllButton)
        showAllButton.addTarget(self, action: #selector(self.showAllButtonDidTap(_:)), for: .touchUpInside)
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateConstraints() {
        NSLayoutConstraint.activate([
            separatorLineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            separatorLineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            separatorLineView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),

            titleLabel.leadingAnchor.constraint(equalTo: separatorLineView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            showAllButton.trailingAnchor.constraint(equalTo: separatorLineView.trailingAnchor),
            showAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])

        super.updateConstraints()
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    @objc func showAllButtonDidTap(_ sender: UIButton) {
        print("button did tap")
    }
}

