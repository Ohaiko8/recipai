import UIKit

class RecipesListViewController: UIViewController {
    private var recipes = [Recipe]()
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes"
        configureTableView()
        fetchRecipes()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func fetchRecipes() {
        guard let url = URL(string: "https://arcane-inlet-68716-cb2613b7d4fb.herokuapp.com/recipes") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching recipes: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                self?.recipes = try JSONDecoder().decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Failed to decode recipes: \(error)")
            }
        }.resume()
    }
    
    // This function should be called from SceneDelegate when an image is analyzed.
    func analyzeImageWithClarifai(image: UIImage) {
        print("Calling analyzeImageWithClarifai")
        guard let imageData = image.jpegData(compressionQuality: 0.9)?.base64EncodedString() else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        print("Image data size: \(imageData.count)")
        
        let apiKey = "051458aee97c4432a8aa599e27f798e6" // Replace with your real API key
            let url = URL(string: "https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "inputs": [
                [
                    "data": [
                        "image": [
                            "base64": imageData
                        ]
                    ]
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        // URLSession data task to send the image to Clarifai and process the response
        print("Executing URLSession data task")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        print("Error during Clarifai request: \(error?.localizedDescription ?? "Unknown error")")
                        self?.showAlert(with: "Error", message: error?.localizedDescription ?? "Unknown error")
                    }
                    return
                }

                // Process the response
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let outputs = json["outputs"] as? [[String: Any]],
                       let firstOutput = outputs.first,
                       let data = firstOutput["data"] as? [String: Any],
                       let concepts = data["concepts"] as? [[String: Any]] {

                        let filteredIngredients = concepts.compactMap { concept -> String? in
                            guard let name = concept["name"] as? String,
                                  let value = concept["value"] as? NSNumber,
                                  value.doubleValue > 0.01 else {
                                return nil
                            }
                            return name // We return only the name here
                        }
                        
                        if filteredIngredients.isEmpty {
                            print("No ingredients above the confidence threshold were found in the JSON response.")
                            DispatchQueue.main.async {
                                self?.showAlert(with: "No Ingredients", message: "No ingredients above the confidence threshold were detected in the image.")
                            }
                        } else {
                            let ingredientsText = filteredIngredients.joined(separator: "\n")
                            print("Detected ingredients: \(ingredientsText)")
                            DispatchQueue.main.async {
                                self?.showIngredientsPopup(with: ingredientsText)
                            }
                        }

                    } else {
                        print("The JSON structure received from Clarifai did not match the expected format.")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Failed to decode JSON response: \(error)")
                        self?.showAlert(with: "Error", message: "Failed to decode JSON response: \(error)")
                    }
                }
            }.resume()
        }
    private func showAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func showIngredientsPopup(with ingredients: String) {
        let alertController = UIAlertController(title: "Detected Ingredients", message: ingredients, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as? RecipeTableViewCell else {
            fatalError("Unable to dequeue RecipeTableViewCell")
        }
        cell.configure(with: recipes[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Adjust based on your UI design
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement navigation logic to detail view if applicable
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RecipesListViewController {
    // Utility method to show an alert with a title and message
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func showIngredientsPopup(ingredients: String) {
        let alertController = UIAlertController(title: "Detected Ingredients", message: ingredients, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Optionally, handle the OK action, such as navigating to another screen
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
