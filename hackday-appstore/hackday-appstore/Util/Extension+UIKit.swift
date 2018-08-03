//
//  Extension+UIKit.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

protocol Reusable: class {}

// [멘토] cell의 property 중에 reusableIdentifier가 있는데 identifier를 설정하는 이유는? 자기 자신의 description을 id로 사용하기 위해서? 의도한 것인가?
// 같은 cell인데 initialize에서 다르게 표현해야하는 경우 같은 id를 사용하기 때문에 reuse되는 과정에서 오동작할 수 있음. 가능하면 id값을 상황에 맞게 설정하는 것이 좋을 것으로 보임

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol ConfigurableCell: Reusable {
    // [멘토] 연관 타입에 대해서 사용법을 알고 있는지 확인 필요
    associatedtype T
    func configure(_ cellModel: [T])
}

struct ViewMaker {
    static func createSeparatorLineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        lineView.autoLayout
        return lineView
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UIViewController: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

// [멘토] 미리 정의하여 사용하는 것은 좋은 습관이나, 이 코드는 필요없는 코드로 보임. 차라리 static으로 선언하거나 다른식으로 만드는 것이 좋아보임
struct Constant {
    var leading: CGFloat = 0
    var trailing: CGFloat = 0
    var top: CGFloat = 0
    var botton: CGFloat = 0
}

extension UIView {
    // [멘토] 추상화 레벨을 높이기 위한 작업으로 이런 습관은 좋음
    var autoLayout: Void {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    // [멘토] Constant를 input에서 생성했는데 불필요함
    func fillSuperview(_ constant: Constant = Constant()) {
        self.autoLayout
        if let superview = self.superview {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant.leading),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant.trailing),
                topAnchor.constraint(equalTo: superview.topAnchor, constant: constant.top),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant.botton)
                ])
        }
    }
}

// [멘토] 수정: UIDataSourceTranslating 확장하여 UITableView / UICollectionView 모두 따를 수 있도록 사용
extension UIDataSourceTranslating {
    func dequeueReusableCell<Cell: Reusable>(of cellClass: Cell.Type ,for indexPath: IndexPath) -> Cell? {
        
        if let tableView = self as? UITableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
                return nil
            }
            return cell
        } else if let collectionView = self as? UICollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
                return nil
            }
            return cell
        } else {
            return nil
        }
        
    }
    
    func dequeueReusableView<Cell: Reusable>() -> Cell? {
        guard let tableView = self as? UITableView, let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier) as? Cell else {
            return nil
        }
        return view
    }
}

// [멘토] UITableView와 UICollectionView는 UIDataSourceTranslating protocol을 따르고 있기 때문에, 이 프로토콜을 확장하여 사용하는 것도 좋을 것같음
//extension UITableView {
//
//    // [멘토] configurableCell은 reusable protocol을 상속하고 있기 때문에, 아래 function으로 사용해되 될 것 같음
////    func dequeueReusableCell<Cell: ConfigurableCell>(of cellClass: Cell.Type ,for indexPath: IndexPath) -> Cell? {
////        guard let cell = dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
////            return nil
////        }
////        return cell
////    }
//
//    func dequeueReusableCell<Cell: Reusable>(of cellClass: Cell.Type ,for indexPath: IndexPath) -> Cell? {
//        guard let cell = dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
//            return nil
//        }
//        return cell
//    }
//
//    func dequeueReusableView<Cell: Reusable>() -> Cell? {
//        guard let view = dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier) as? Cell else {
//            return nil
//        }
//        return view
//    }
//
//}
//
//extension UICollectionView {
//
//    func dequeueReusableCell<Cell: Reusable>(of cellClass: Cell.Type ,for indexPath: IndexPath) -> Cell? {
//        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
//            return nil
//        }
//        return cell
//    }
//}

extension UIColor {

    static var appStoreBlue: UIColor {
        return UIColor.rgb(red: 54, green: 124, blue: 246, alpha: 1)
    }

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/256, green: green/256, blue: blue/256, alpha: alpha)
    }
}

extension UIImage {

    enum Icon {
        static let user: UIImage = UIImage(named: "user")!
        static let downloadapp: UIImage = UIImage(named: "downloadapp")!
    }
}
