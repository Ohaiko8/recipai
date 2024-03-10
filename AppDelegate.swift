import UIKit
import Cloudinary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var cloudinary: CLDCloudinary!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup Cloudinary configuration
        let config = CLDConfiguration(cloudName: "dqvnjehbs", apiKey: "456752749853931", apiSecret: "sQbyYH_uqX_GzBML-Pp_Bk579Yc", secure: true)
        cloudinary = CLDCloudinary(configuration: config)
        
        if #available(iOS 13, *) {
            // Leave window setup to SceneDelegate
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let customTabBarController = RecipesListViewController()
            self.window?.rootViewController = customTabBarController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // Add UISceneSession lifecycle methods if you are using iOS 13 or later.
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
