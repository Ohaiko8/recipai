import UIKit

class RecipesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var recipes = [Recipe]()
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes"
        setupTableView()
        fetchRecipes()
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        tableView.dataSource = self
        tableView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }

    private func fetchRecipes() {
        guard let url = URL(string: "https://arcane-inlet-68716-cb2613b7d4fb.herokuapp.com/recipes") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    self?.recipes = recipes
                    self?.tableView.reloadData()
                }
            } catch {
                print("An error occurred: \(error)")
            }
        }.resume()
    }

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        return cell
    }

    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        let detailVC = RecipeDetailViewController()
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
