import Foundation

// Define a struct for an Ingredient to be used within the Recipe
struct Ingredient: Codable {
    var name: String
    var quantity: String // Quantity includes both the amount and the unit (e.g., "2 cups")
}

// Define the Recipe model
struct Recipe: Codable {
    var id: Int
    var title: String
    var description: String
    var ingredients: [Ingredient]
    var instructions: String
    var preparationTime: Int // Time in minutes
    var cookingTime: Int // Time in minutes
    var servings: Int
}
