import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create a window that is the same size as the device's screen
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create an instance of the RecipesListViewController
        let recipesListVC = RecipesListViewController()
        
        // Create a UINavigationController with recipesListVC as its root view controller
        let navigationController = UINavigationController(rootViewController: recipesListVC)
        
        // Set the window's root view controller to be the navigation controller
        window?.rootViewController = navigationController
        
        // Make the window visible
        window?.makeKeyAndVisible()
        
        return true
    }

    // You might need to implement additional delegate methods depending on your app's requirements
}
