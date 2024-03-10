import UIKit
import Cloudinary

class AddRecipeConfirmationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // UI Elements
    private var explanationLabel: UILabel!
    private var imageView: UIImageView!
    private var nameTextField: UITextField!
    private var ingredientsTextView: UITextView!
    private var recipeTextView: UITextView!
    private var recipeExplanationLabel: UILabel!
    private var cookingTimePicker: UIDatePicker!
    private var cancelButton: UIButton!
    private var addRecipeButton: UIButton!
    private var instructionLabel: UILabel!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var timePickerLabel: UILabel!
    
    // Data
    var selectedImage: UIImage?
    var ingredientsText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupHideKeyboardOnTap()
        setupScrollView()
        setupUI()
        registerForKeyboardNotifications()
    }
    
    private func setupUI() {
        setupImageView()
        setupNameTextField()
        setupIngredientsTextView()
        setupRecipeTextView()
        setupCookingTimePicker()
        setupButtons()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.layoutIfNeeded()
        
        // Calculate the height of the contentView based on the maxY of the last view + some padding
        contentView.heightAnchor.constraint(equalToConstant: 1300).isActive = true
        
        // Set the scrollView's contentSize
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: 1300)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // This allows other controls to receive touch events
        view.addGestureRecognizer(tapGesture)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // UITextFieldDelegate method to dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    // Call this method to dismiss the keyboard for a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.tintColor = .white
        
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == recipeTextView && textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .darkGray  // Text color for regular input
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == recipeTextView && textView.text.isEmpty {
            textView.text = "Enter your recipe here.\n\nE.g., Combine 1 cup flour with 1/2 cup sugar..."
            textView.textColor = .lightGray  // Reapply placeholder text color
        }
    }
    
    // Implement tap gesture to dismiss keyboard
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  // This will dismiss the keyboard
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = selectedImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        // Top gradient
        let topGradientLayer = CAGradientLayer()
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        topGradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [0, 1]
        imageView.layer.insertSublayer(topGradientLayer, at: 0)
        
        // Bottom gradient
        let bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.frame = CGRect(x: 0, y: imageView.bounds.height - 100, width: UIScreen.main.bounds.width, height: 100)
        bottomGradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        bottomGradientLayer.locations = [1, 0]
        imageView.layer.insertSublayer(bottomGradientLayer, at: 0)
    }
    
    private func setupNameTextField() {
        nameTextField = UITextField()
        
        // Set the placeholder text color to light gray
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name of the Dish",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        // Set entered text color to gray and increase the font size
        nameTextField.textColor = UIColor.darkGray
        nameTextField.font = UIFont.systemFont(ofSize: 24) // Adjust the font size as needed
        
        nameTextField.borderStyle = .none
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTextField)
        
        // Create an underline for the text field
        let bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = .orange
        
        nameTextField.addSubview(bottomLine)
        nameTextField.bringSubviewToFront(bottomLine)
        
        // Constraints for nameTextField
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40) // Adjust the height as needed
        ])
        
        // Constraints for the underline view
        NSLayoutConstraint.activate([
            bottomLine.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -5), // Adding bottom padding
            bottomLine.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2) // Height of the underline
        ])
    }
    
    private func setupIngredientsTextView() {
        ingredientsTextView = UITextView()
        ingredientsTextView.backgroundColor = .white // Ensures background is white in all modes
        ingredientsTextView.textColor = .darkGray // Sets text color to gray
        ingredientsTextView.font = UIFont.systemFont(ofSize: 18) // Sets text size to 18
        ingredientsTextView.text = ingredientsText ?? "Ingredients" // Sets initial text
        ingredientsTextView.layer.borderColor = UIColor.orange.cgColor
        ingredientsTextView.layer.borderWidth = 1
        ingredientsTextView.layer.cornerRadius = 5
        ingredientsTextView.isEditable = true
        ingredientsTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ingredientsTextView)
        
        NSLayoutConstraint.activate([
            ingredientsTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 60),
            ingredientsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ingredientsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        explanationLabel = UILabel()
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.text = "List of ingredients:"
        explanationLabel.font = UIFont.systemFont(ofSize: 20)
        explanationLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        explanationLabel.textColor = .darkGray
        contentView.addSubview(explanationLabel)
        
        NSLayoutConstraint.activate([
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            explanationLabel.bottomAnchor.constraint(equalTo: ingredientsTextView.topAnchor, constant: -8)
        ])
    }
    
    private func setupRecipeTextView() {
        // Initialize and configure recipeExplanationLabel
        recipeExplanationLabel = UILabel()
        recipeExplanationLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeExplanationLabel.text = "Your recipe:"
        recipeExplanationLabel.font = UIFont.systemFont(ofSize: 20)
        recipeExplanationLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        recipeExplanationLabel.textColor = .darkGray
        contentView.addSubview(recipeExplanationLabel)
        
        // Constraints for recipeExplanationLabel
        NSLayoutConstraint.activate([
            recipeExplanationLabel.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 40),
            recipeExplanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeExplanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Initialize recipeTextView
        recipeTextView = UITextView()
        recipeTextView.delegate = self
        recipeTextView.layer.borderColor = UIColor.orange.cgColor
        recipeTextView.layer.borderWidth = 1.0
        recipeTextView.layer.cornerRadius = 5.0
        recipeTextView.isEditable = true
        recipeTextView.isUserInteractionEnabled = true
        recipeTextView.backgroundColor = .white
        recipeTextView.font = UIFont.systemFont(ofSize: 18)
        recipeTextView.text = "Enter your recipe here.\n\nE.g., Combine 1 cup flour with 1/2 cup sugar..."
        recipeTextView.textColor = .lightGray
        recipeTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeTextView)
        
        // Update recipeTextView constraints to be below recipeExplanationLabel
        NSLayoutConstraint.activate([
            recipeTextView.topAnchor.constraint(equalTo: recipeExplanationLabel.bottomAnchor, constant: 8),
            recipeTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recipeTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recipeTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func setupCookingTimePicker() {
        // Create and configure cooking time description label
        let cookingTimeDescriptionLabel = UILabel()
        cookingTimeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cookingTimeDescriptionLabel.text = "Select recipe cooking time"
        cookingTimeDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
        cookingTimeDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        cookingTimeDescriptionLabel.textColor = .darkGray
        contentView.addSubview(cookingTimeDescriptionLabel)
        
        // Create and configure the date picker
        cookingTimePicker = UIDatePicker()
        cookingTimePicker.datePickerMode = .countDownTimer
        cookingTimePicker.preferredDatePickerStyle = .wheels // You can set .inline for a more modern style if you prefer
        // Set the background color of the time picker to make it stand out on a white background
        cookingTimePicker.backgroundColor = UIColor.systemGray6
        // Set a border to make it stand out more if needed
        cookingTimePicker.layer.borderColor = UIColor.lightGray.cgColor
        cookingTimePicker.layer.borderWidth = 0.5
        cookingTimePicker.layer.cornerRadius = 8
        cookingTimePicker.clipsToBounds = true
        cookingTimePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cookingTimePicker)
        
        // Add constraints for the cooking time description label
        NSLayoutConstraint.activate([
            cookingTimeDescriptionLabel.topAnchor.constraint(equalTo: recipeTextView.bottomAnchor, constant: 40),
            cookingTimeDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cookingTimeDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Add constraints for the cooking time picker
        NSLayoutConstraint.activate([
            cookingTimePicker.topAnchor.constraint(equalTo: cookingTimeDescriptionLabel.bottomAnchor, constant: 10),
            cookingTimePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cookingTimePicker.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    
    private func setupButtons() {
        // Initialize the cancel button with a system type for default styling.
        cancelButton = UIButton(type: .system)
        // Remove any text title that was previously set.
        cancelButton.setTitle("", for: .normal)
        // Set the background color to red.
        cancelButton.backgroundColor = .red
        // Add a system image of a cross or a trash can. Here we're using 'xmark' as an example.
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        // Adjust the image tint color to white so it stands out against the red background.
        cancelButton.tintColor = .white
        // Make the button circular by setting the corner radius to half the width or height.
        // The button will need to have a fixed width and height for the corner radius to create a perfect circle.
        cancelButton.layer.cornerRadius = 25 // Half of the width and height below.
        // Disable autoresizing mask translation and add the button to the view.
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        // Initialize the addRecipeButton as previously set.
        addRecipeButton = UIButton(type: .system)
        addRecipeButton.setTitle("Add Recipe", for: .normal)
        addRecipeButton.backgroundColor = UIColor.orange
        addRecipeButton.setTitleColor(.white, for: .normal)
        addRecipeButton.layer.cornerRadius = 25
        addRecipeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addRecipeButton)
        
        addRecipeButton.addTarget(self, action: #selector(addRecipeAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        // Activate constraints for both buttons.
        NSLayoutConstraint.activate([
            // Since the cancelButton is circular and does not have a text title, the width and height should be equal.
            cancelButton.widthAnchor.constraint(equalToConstant: 50), // Width of the circular button
            cancelButton.heightAnchor.constraint(equalToConstant: 50), // Height of the circular button
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // The constraints for the addRecipeButton remain the same.
            addRecipeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            addRecipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addRecipeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            addRecipeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func updateScrollViewContentSize() {
        let width = scrollView.bounds.width
        let height = imageView.frame.height + nameTextField.frame.height + ingredientsTextView.frame.height + recipeTextView.frame.height + cookingTimePicker.frame.height + cancelButton.frame.height + 16000 // Adjust the value to fit all your subviews nicely
        scrollView.contentSize = CGSize(width: width, height: height)
    }
    
    
    
    @objc private func cancelAction() {
        // Check if the view controller is being presented modally or pushed onto a navigation stack
        if isBeingPresented || presentingViewController != nil {
            // Dismiss modal presentation
            dismiss(animated: true, completion: nil)
        } else if let navigationController = navigationController {
            // Pop off the navigation stack
            navigationController.popViewController(animated: true)
        } else {
            // Fallback if not presented modally or in a navigation stack, just dismiss it
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc private func addRecipeAction() {
        guard let name = nameTextField.text, !name.isEmpty,
              let ingredients = ingredientsTextView.text, !ingredients.isEmpty,
              let instructions = recipeTextView.text, !instructions.isEmpty,
              let selectedImage = selectedImage else {
            showAlert(message: "Please ensure all fields are filled and an image is selected.")
            return
        }
        
        uploadImageToCloudinary(image: selectedImage) { [weak self] imageUrl in
            guard let imageUrl = imageUrl else {
                self?.showAlert(message: "Image upload failed. Please try again.")
                return
            }
            
            let cookingTimeMinutes = Int((self?.cookingTimePicker.countDownDuration ?? 0 ) / 60)
            let cookingTimeString = "\(cookingTimeMinutes) minutes"
            let creationDate = ISO8601DateFormatter().string(from: Date())
            
            // Now you have the imageUrl, proceed to create your recipe data dictionary
            let recipeData: [String: Any] = [
                "title": name,
                "image_path": imageUrl,
                "cooking_time": cookingTimeString,
                "ingredients": ingredients,
                "instructions": instructions,
                "creation_date": creationDate
            ]
            
            // Assume postRecipe is a function that takes recipe data and a completion handler
            self?.postRecipe(recipeData) { isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        self?.showAlertWithCompletion(message: "Recipe added successfully.") {
                            if self?.isBeingPresented ?? false || self?.presentingViewController != nil {
                                self?.dismiss(animated: true, completion: nil)
                            } else if let navigationController = self?.navigationController {
                                navigationController.popViewController(animated: true)
                            } else {
                                self?.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else {
                        self?.showAlert(message: "Failed to add the recipe. Please try again.")
                    }
                }
            }
            
        }
    }
    
    func showAlertWithCompletion(message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    func postRecipe(_ recipeData: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://arcane-inlet-68716-cb2613b7d4fb.herokuapp.com/recipes") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: recipeData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    print("Recipe added successfully")
                    completion(true)
                } else {
                    // If possible, decode the server response to get detailed error message
                    if let data = data, let body = String(data: data, encoding: .utf8) {
                        print("Server Error: \(body)")
                    }
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    
    func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?) -> Void) {
        // Setup Cloudinary configuration
        let config = CLDConfiguration(cloudName: "dqvnjehbs", apiKey: "456752749853931", apiSecret: "sQbyYH_uqX_GzBML-Pp_Bk579Yc", secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        
        // Assuming image is your UIImage
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        // Upload image data
        cloudinary.createUploader().upload(data: imageData, uploadPreset: "cewde6jd") { result, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                completion(nil)
            } else if let result = result, let url = result.url {
                print("Image uploaded")
                completion(url)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    private func adjustLayoutForVisibility() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
