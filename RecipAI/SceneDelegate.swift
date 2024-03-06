import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let recipesListVC = RecipesListViewController()
        let navigationController = UINavigationController(rootViewController: recipesListVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
