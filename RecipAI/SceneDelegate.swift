import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let imagePickerController = UIImagePickerController()
    var captureButton: UIButton?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Setup the initial view controller
        let recipesListViewController = RecipesListViewController()
        let navigationController = UINavigationController(rootViewController: recipesListViewController)
        
        // Setup the window
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        
        // Make sure the window is visible
        window?.makeKeyAndVisible()
        
        // Setup the capture button
        setupCaptureButton()
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.delegate = self  // Set the navigation controller delegate
        }
    }
    
    private func setupCaptureButton() {
        guard let window = self.window else { return }
        
        if captureButton == nil {
            let button = UIButton(frame: CGRect(x: window.frame.width - 90, y: window.frame.height - 140, width: 60, height: 60))
            button.backgroundColor = .orange // Change color to orange
            button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
            button.tintColor = .white
            button.layer.cornerRadius = 30
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
            
            window.addSubview(button)
            captureButton = button
        }
    }
    
    @objc private func captureButtonTapped() {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .photoLibrary)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the action sheet
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = captureButton
            popoverController.sourceRect = captureButton?.bounds ?? CGRect.zero
            popoverController.permittedArrowDirections = []
        }
        
        window?.rootViewController?.present(actionSheet, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        // Present the image picker controller
        window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SceneDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Retrieve the captured or selected image
        guard let image = info[.originalImage] as? UIImage else { return }
        
        // Find the RecipesListViewController instance from the navigation stack
        if let navigationController = window?.rootViewController as? UINavigationController,
           let recipesListViewController = navigationController.viewControllers.first(where: { $0 is RecipesListViewController }) as? RecipesListViewController {
            // Call the analyzeImageWithClarifai(image:) method with the selected image
            recipesListViewController.analyzeImageWithClarifai(image: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Check if we're showing the specific view controller that should hide the capture button
        if viewController is AddRecipeConfirmationViewController {
            captureButton?.isHidden = true
        } else {
            captureButton?.isHidden = false
        }
    }
}
