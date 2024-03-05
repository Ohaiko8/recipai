import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create the window and set the windowScene
        window = UIWindow(windowScene: windowScene)
        
        // Setup the root view controller
        let recipesListVC = RecipesListViewController()
        let navigationController = UINavigationController(rootViewController: recipesListVC)
        window?.rootViewController = navigationController
        
        // Make the window visible
        window?.makeKeyAndVisible()
    }
}
