
import  UIKit
import Alamofire
struct Utile {
    
    static let getWindow = UIApplication.shared.windows.first
    static let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    static var labelMessage = UILabel()
    static var activityView = UIView()
    
    /// This method is used to get object if AppDelegate
    ///
    /// - returns: Object of AppDelegate
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK:- manage FontSize According to iphone's screen
    static func getFontSizeAcordingToDevices( currentFontSize: CGFloat) -> CGFloat {
        var fontSize = CGFloat(0)
        switch UIDevice.screenType {
            
        case .iPhones_5_5s_5c_SE:
            fontSize = currentFontSize - 2
            
        case .iPhoneXR:
            fontSize = currentFontSize + 3
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            fontSize = currentFontSize + 1
            
        case .iPhoneX_iPhoneXS:
            fontSize = currentFontSize - 0.3
            
        case .iPhoneXSMax:
            fontSize = currentFontSize + 3
        default:
            fontSize = currentFontSize
        }
        return fontSize
    }
    
    /// This method is used to show activity indicator.
    static func showActivityIndicator() {
        let appWindow: UIWindow? = Utile.appDelegate().window
        activityIndicator.color = UIColor.themePinkColor
        activityIndicator.startAnimating()
        appWindow?.alpha = 0.9
        let viewController = getCurrentViewController()
        viewController?.view.addSubview(activityIndicator)
        viewController?.view.isUserInteractionEnabled = false
        viewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        Utile.addConstraint(activityIndicator)
    }
    
    
    static func showActivityIndicatorWithMessage(message: String) {
        
        let appWindow: UIWindow? = Utile.appDelegate().window
        activityIndicator.color = UIColor.themePinkColor
        let viewController = getCurrentViewController()
        appWindow?.alpha = 0.9
        
        activityView.frame = CGRect(x: ((viewController?.view.frame.origin.x ?? 0) + 50), y: (UIDevice.deviceHeight() / 2 - 65) , width: UIDevice.deviceWidth() - 100 , height: 110)
        activityView.backgroundColor = UIColor.lightGrayColor
        activityView.layer.cornerRadius = 5
        activityView.layer.masksToBounds = true
        
        activityView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint.init(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator.superview, attribute: .centerX, multiplier: 1, constant: 1)
        horizontalConstraint.isActive = true
        
        let verticalConstraint = NSLayoutConstraint.init(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator.superview, attribute: .centerY, multiplier: 1, constant: -20)
        verticalConstraint.isActive = true
        activityIndicator.startAnimating()
        
        labelMessage.frame = CGRect(x: 0, y: 60, width: activityView.frame.width, height: 40)
        labelMessage.text = message
        labelMessage.textColor = UIColor.themePinkColor
        labelMessage.textAlignment = .center
       // labelMessage.font = UIFont(name: AppFont.thin, size: 18)
        activityView.addSubview(labelMessage)
        viewController?.view.addSubview(activityView)
        viewController?.view.isUserInteractionEnabled = false
        viewController?.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    /// This method is used to hide Activity indicator.
    static func hideActivityIndicator() {
        let appWindow: UIWindow? = Utile.appDelegate().window
        appWindow?.alpha = 1.0
        activityIndicator.stopAnimating()
        let viewController = getCurrentViewController()
        viewController?.view.isUserInteractionEnabled = true
        activityIndicator.removeFromSuperview()
    }
    
    static func hideMessageActivityIndicator() {
        let appWindow: UIWindow? = Utile.appDelegate().window
        appWindow?.alpha = 1.0
        activityIndicator.stopAnimating()
        let viewController = getCurrentViewController()
        viewController?.view.isUserInteractionEnabled = true
        viewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        activityView.removeFromSuperview()
    }
    
    /// This method add constraints on activity indicator
    ///
    /// - parameter view: Indicator view
    fileprivate static func addConstraint(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 1)
        horizontalConstraint.isActive = true
        
        let verticalConstraint = NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: 1)
        verticalConstraint.isActive = true
        
    }
    
    // check connectivity.
    static func isInternetAvailable() -> Bool {
        return (NetworkReachabilityManager()?.isReachable ?? false)
    }
    
    
    /// This method used to get device language code
    ///
    /// - Returns: deviceLanguageCode
    static func deviceLanguageCode() -> String {
        return Locale.current.languageCode ?? "en"
    }
    
    /// This method used to get device language
    ///
    /// - Returns: deviceLanguage
    static func deviceLanguage() -> String {
        return Locale.current.localizedString(forLanguageCode: deviceLanguageCode()) ?? "English"
    }
    
    static func getCurrentViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first
        let rootVC = window?.rootViewController
        var currentVC:UIViewController?
        
        if rootVC is UITabBarController {
            currentVC = (rootVC as! UITabBarController).selectedViewController
            if currentVC is UINavigationController {
                let navController = currentVC as! UINavigationController
                currentVC = navController.visibleViewController
            }
        }
        else if rootVC is UINavigationController {
            let navController = rootVC as! UINavigationController
            currentVC = navController.visibleViewController
        } else if rootVC != nil {
            currentVC = rootVC
        }
        return currentVC
    }
 
    
    static func dictToJSON(dictionary:[String:Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getServerDateFormate(from:Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: from)
        return result
    }
    
    static func stringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:dateString)!
        return date
    }
    
    static func getGMTTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let date = dateFormatter.string(from: Date())
        print(date)
        return date
    }
}
