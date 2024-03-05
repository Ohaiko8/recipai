import UIKit

class RecipeListViewController: UIViewController {
    var tableView: UITableView!
    var recipes = [Recipe]() // Array to hold your recipes

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchRecipes()
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        // Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func fetchRecipes() {
        // Replace with your actual backend URL
        guard let url = URL(string: "https://yourbackend.com/api/recipes") else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching recipes: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Invalid response from the server")
                return
            }

            guard let data = data else {
                print("Error: No data received")
                return
            }

            do {
                // Decode the JSON data into an array of Recipe objects
                let decoder = JSONDecoder()
                let recipes = try decoder.decode([Recipe].self, from: data)

                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        return cell
    }
}

extension RecipeListViewController: UITableViewDelegate {
    // Implement any delegate methods if needed, such as didSelectRowAt
}
