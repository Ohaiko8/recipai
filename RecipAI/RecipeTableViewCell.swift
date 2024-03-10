import UIKit

class RecipeTableViewCell: UITableViewCell {
    static let identifier = "RecipeTableViewCell"
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cookingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Add subviews
        addSubview(recipeImageView)
        addSubview(titleLabel)
        addSubview(ingredientsLabel)
        addSubview(instructionsLabel)
        addSubview(cookingTimeLabel)
        
        // Set up constraints for the recipe image view
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            recipeImageView.heightAnchor.constraint(equalToConstant: 200), 
        ])
        
        // Set up constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
        // Set up constraints for the ingredients label
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            ingredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
        // Set up constraints for the instructions label
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 10),
            instructionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            instructionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
        // Set up constraints for the cooking time label
        NSLayoutConstraint.activate([
            cookingTimeLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10),
            cookingTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cookingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cookingTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10), // This ensures padding at the bottom
        ])
        ingredientsLabel.numberOfLines = 0
    }
    
    // Configure cell with data
    func configure(with model: Recipe) {
        titleLabel.text = model.title
        ingredientsLabel.text = "Ingredients: " + model.ingredients.split(separator: "\n").joined(separator: ", ")
        instructionsLabel.text = "Instructions:\n\(model.instructions)"
        cookingTimeLabel.text = "Cooking time: \(model.cookingTime)"
        
        // Load the image asynchronously
        if let imageUrl = model.imagePath, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.recipeImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
