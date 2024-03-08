class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureImageButton()
    }

    private func setupCaptureImageButton() {
        let captureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        captureButton.backgroundColor = .systemBlue
        captureButton.layer.cornerRadius = 35
        captureButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        captureButton.tintColor = .white
        captureButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.minY - 15)
        captureButton.addTarget(self, action: #selector(captureImageAction), for: .touchUpInside)

        tabBar.addSubview(captureButton)
        tabBar.layer.masksToBounds = false
    }

    @objc func captureImageAction() {
        // Implement image capture functionality here
        presentImagePickerController()
    }

    private func presentImagePickerController() {
        // Similar to the UIImagePickerController setup shown earlier
    }
}
