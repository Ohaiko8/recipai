import Foundation

struct Recipe: Codable {
    var recipeID: Int
    var title: String
    var description: String
    var instructions: String
    var preparationTime: Int
    var cookingTime: Int
    var servings: Int
    var imageUrl: String? // Newly added field

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipeid"
        case title
        case description
        case instructions
        case preparationTime = "preparationtime"
        case cookingTime = "cookingtime"
        case servings
        case imageUrl = "image_url" // Ensure this matches your database column name
    }
}

struct Ingredient: Codable {
    var ingredientID: Int
    var name: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case ingredientID = "ingredientid"
        case name
        case description
    }
}

struct RecipeIngredient: Codable {
    var recipeID: Int
    var ingredientID: Int
    var quantity: Decimal
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case recipeID = "recipeid"
        case ingredientID = "ingredientid"
        case quantity
        case unit
    }
}

struct UserImage: Codable {
    var imageID: Int
    var recipeID: Int
    var imageURL: String
    var uploadTime: Date // Assuming you will handle the date conversion
    
    enum CodingKeys: String, CodingKey {
        case imageID = "imageid"
        case recipeID = "recipeid"
        case imageURL = "imageurl"
        case uploadTime = "uploadtime"
    }
}

// Define the top-level structure that corresponds to the JSON response
struct ClarifaiResponse: Codable {
    let status: Status
    let model: Model
    let data: DataClass
}

// Define the status structure
struct Status: Codable {
    let code: Int
    let description: String
}

// Define the model structure
struct Model: Codable {
    let id: String
    let name: String
    let modelVersion: ModelVersion

    enum CodingKeys: String, CodingKey {
        case id, name
        case modelVersion = "model_version"
    }
}

// Define the model version structure
struct ModelVersion: Codable {
    let id: String
    let status: Status
}

// Define the data class to hold concepts
struct DataClass: Codable {
    let concepts: [Concept]
}

// Define the concept structure to hold individual food items
struct Concept: Codable {
    let id: String
    let name: String
    let value: Float
    let appId: String

    enum CodingKeys: String, CodingKey {
        case id, name, value
        case appId = "app_id"
    }
}
