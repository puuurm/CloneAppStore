import UIKit

struct Apps: Decodable {
    var appInfo: [App]?
}

struct App: CustomStringConvertible, Comparable, Decodable {
    var description: String {
        return """

        =========================================================
        App Name        : \(String(describing: self.info!.name!))
        App ID          : \(String(describing: self.appId!))
        App Category    : \(String(describing: self.info!.categoryInfo!.categoryId!))

        """
    }

    var appId: String?
    var info: AppInfo?
    var resource: AppResource?

    static func == (lhs: App, rhs: App) -> Bool {
        return lhs.appId! == rhs.appId!
    }

    static func < (lhs: App, rhs: App) -> Bool {
        return Int((lhs.info?.rank)!)! < Int((rhs.info?.rank)!)!
    }

    func isSameCategory (category: Category) -> Bool {
        return (info?.categoryInfo?.categoryId)! == category.categoryId!
    }

    func isFreeApp() -> Bool {
        return (info?.priceInfo)!.isFree()
    }

    func icon() -> UIImage? {
        return resource!.appIcon()
    }
}

struct AppInfo: Decodable {
    var company: String?
    var name: String?
    var simpleComment: String?
    var rank: String?
    var versionInfo: AppVersion?
    var categoryInfo: AppCategory?
    var priceInfo: AppPrice?
}

struct AppVersion : Comparable, Decodable {
    var version: String?
    var versionDescription: String?
    var updateDate: String?

    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return lhs.version! < rhs.version!
    }

    static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return lhs.version! == rhs.version!
    }
}

struct AppCategory: Decodable {
    var category: String?
    var categoryId: String?
}

struct AppPrice: Decodable {
    var type: String?
    var price: String?

    func isFree() -> Bool {
        return type! == "free"
    }

    func appPrice() -> String {
        return type == "free" ? type! : price!
    }
}

struct AppResource: Decodable {
    var icon: String?
    var backgroundColor: AppBackgroundColor?

//    func appBgColor() -> UIColor {
//        return UIColor(red: CGFloat(Float(backgroundColor.red)!/255.0), green: CGFloat(Float(backgroundColor!.green!)!/255.0), blue: CGFloat(Float(backgroundColor!.blue!)!/255.0), alpha: 1.0)
//    }

    func appIcon() -> UIImage? {
        return UIImage(named: icon!)
    }
}

struct AppBackgroundColor: Decodable {
    var red: String?
    var green: String?
    var blue: String?
}
