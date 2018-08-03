//
//  AppViewController.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 15..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

extension String {
    static let newRecommenedTitle = "새롭게 추천하는 앱"
    static let paidRankedTitle = "유료 순위"
    static let freeRankedTitle = "무료 순위"
    static let favoriteCategoryTitle = "인기 카테고리"
}


enum Section: Int {
    case recomended
    case newRecommened
    case paidRanked
    case freeRanked
    case favoriteCategory
    
    private static let titleList: [String] = ["", .newRecommenedTitle, .paidRankedTitle, .freeRankedTitle, .favoriteCategoryTitle]
    var title: String {
        if rawValue < Section.numberOfSections {
            return Section.titleList[rawValue]
        }
        return ""
    }
    var headerHeight: CGFloat {
        return rawValue == 0 ? 0 : 50
    }
    
    var rowHeight: CGFloat {
        switch rawValue {
        case 0, 4: return 300
        case 1, 2, 3: return 200
        default: return 0
        }
    }
    
    static var numberOfSections: Int { return titleList.count }
    static let numberOfRows: Int = 1
}

class AppViewController: UITableViewController {

    // MARK: - Properties
    var appListInDevice = InstalledAppInfo()
    var allAppList = Apps()
    var appTapConfiguration = AppTapConfiguration()
    var allCategoryInfo = Categories()

    private var recommendedCellData: [(recommendedAppInfo: RecommendedApp , app: App)]?
    private var newRecommendedCellData: [(app: App, status: String)]?
    private var paidRankedCellData: [(app: App, status: String)]?
    private var freeRankedCellData: [(app: App, status: String)]?
    private var favoriteCategoryInfo: [Category]?

    private let cells = [RecommendedAppCell.self, NewRecommendedAppCell.self, RankedAppCell.self, CategoryListCell.self]
    private let views = [SectionHeaderView.self]

    private var offsetWhenScrollViewWillBeginDragging: CGFloat = 0

    private var isFinishRequestAllAppList = false
    private var isFinishRequestAppListInDevice = false
    private var isFinishRequestAppTapConfiguration = false
    private var isFinishRequestCategoryInfo = false

    private let imageView = UIImageView(image: UIImage(named: "user"))

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllInfo()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AppViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .recomended?: return configure(of: RecommendedAppCell.self, for: indexPath, cellModel: recommendedCellData)!
        case .newRecommened?: return configure(of: NewRecommendedAppCell.self, for: indexPath, cellModel: newRecommendedCellData)!
        case .paidRanked?: return configure(of: RankedAppCell.self, for: indexPath, cellModel: paidRankedCellData)!
        case .freeRanked?: return configure(of: RankedAppCell.self, for: indexPath, cellModel: freeRankedCellData)!
        case .favoriteCategory?: return configure(of: CategoryListCell.self, for: indexPath, cellModel: favoriteCategoryInfo)!
        default: break
        }
        return UITableViewCell()
    }

    private func configure<Cell: ConfigurableCell>(of cellClass: Cell.Type ,for indexPath: IndexPath, cellModel: [Cell.T]?) -> Cell? {
        guard let model = cellModel else { return nil }
        let cell = tableView.dequeueReusableCell(of: cellClass, for: indexPath)
        cell?.configure(model)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(rawValue: indexPath.section)
        return section?.rowHeight ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = Section(rawValue: section)
        return section?.headerHeight ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SectionHeaderView? = tableView.dequeueReusableView()
        if let section = Section(rawValue: section) {
            header?.configure(title: section.title)
        }
        return header
    }
}

// MARK: - UIScrollViewDelegate

extension AppViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        if scrollView.contentOffset.y > offsetWhenScrollViewWillBeginDragging {
            navigationBar.sendSubview(toBack: imageView)
        } else {
            navigationBar.bringSubview(toFront: imageView)
        }
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetWhenScrollViewWillBeginDragging = scrollView.contentOffset.y
    }

}
// MARK: - Setup Views

extension AppViewController {

    private func setNavigationItem() {
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true

        guard let navigationBar = self.navigationController?.navigationBar else { return }

        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.autoLayout
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])

    }

    private func setTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        cells.forEach { tableView.register($0, forCellReuseIdentifier: $0.identifier) }
        views.forEach { tableView.register($0, forHeaderFooterViewReuseIdentifier: $0.identifier)}
    }

}

// MARK: - Requst data

extension AppViewController: RecommendedAppListExtractable, RankedAppListExtractable {

    private func loadAllInfo() {
        requestInstalledApp()
        requestAppTapConfiguration()
        requestAllAppList()
        requestCategoryInfo()
    }

    private func requestInstalledApp() {
        do {
            try ApiCenter.requestInfo(.installedApp, success: { [weak self] (model: InstalledAppInfo?) in
                if let installedApp = model {
                    withExtendedLifetime(self) {
                        self?.appListInDevice = installedApp
                        self?.isFinishRequestAppListInDevice = true
                        self?.updateRecommendedCellData()
                    }
                }
            }, failure: nil )
        } catch {
            print(error)
        }
    }

    private func requestAppTapConfiguration() {
        do {
            
            try ApiCenter.requestInfo(.AppTapConfiguration, success: { [weak self] (model: AppTapConfiguration?) in
                if let appTapConfiguration = model {
                    withExtendedLifetime(self) {
                        self?.appTapConfiguration = appTapConfiguration
                        self?.isFinishRequestAppTapConfiguration = true
                        self?.updateRecommendedCellData()
                    }
                }
            }, failure: nil)
        } catch {
            print(error)
        }

    }

    private func requestAllAppList() {
        do {
            try ApiCenter.requestInfo(.appFile, success: { [weak self] (model: Apps?) in
                if let apps = model {
                    withExtendedLifetime(self) {
                        self?.allAppList = apps
                        self?.isFinishRequestAllAppList = true
                        self?.updateRecommendedCellData()
                    }
                }
            }, failure: nil)
        } catch {
            print(error)
        }
    }

    private func requestCategoryInfo() {
        do {
            try ApiCenter.requestInfo(.category, success: { [weak self] (model: Categories?) in
                if let categories = model {
                    withExtendedLifetime(self) {
                        self?.allCategoryInfo = categories
                        self?.favoriteCategoryInfo = categories.categoryInfo?.sorted()
                        self?.isFinishRequestCategoryInfo = true
                        self?.updateRecommendedCellData()
                    }
                }
            }, failure: nil)
        } catch {
            print(error)
        }
    }

    private func updateRecommendedCellData() {
        guard isFinishAllRequest() else {
            return
        }

        self.clearRequestStatus()

        self.recommendedCellData = self.extractRecommendedAppSectionInfo()
        self.newRecommendedCellData = self.extractNewRecommendedAppSectionInfo()
        self.paidRankedCellData = self.extractRankedAppList(category: nil, extractFreeApp: false)
        self.freeRankedCellData = self.extractRankedAppList(category: nil, extractFreeApp: true)
        DispatchQueue.main.async {[weak self] in
            withExtendedLifetime(self) {
                self!.tableView.reloadData()
            }
        }
    }

    private func isFinishAllRequest() -> Bool {
        return isFinishRequestAppTapConfiguration == true && isFinishRequestAllAppList == true && isFinishRequestAppListInDevice == true && isFinishRequestCategoryInfo == true
    }

    private func clearRequestStatus() {
        isFinishRequestAppTapConfiguration = false
        isFinishRequestAppListInDevice = false
        isFinishRequestAllAppList = false
        isFinishRequestCategoryInfo = false
    }


}

struct Const {
    static let ImageSizeForLargeState: CGFloat = 40
    static let ImageRightMargin: CGFloat = 16
    static let ImageBottomMarginForLargeState: CGFloat = 12
    static let ImageBottomMarginForSmallState: CGFloat = 6
    static let ImageSizeForSmallState: CGFloat = 32
    static let NavBarHeightSmallState: CGFloat = 44
    static let NavBarHeightLargeState: CGFloat = 96.5
}
