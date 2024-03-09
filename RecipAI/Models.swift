import Foundation

struct Recipe: Codable {
    var recipeID: Int
    var title: String
    var imagePath: String?
    var cookingTime: String
    var ingredients: String
    var instructions: String
    var creationDate: String

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipe_id"
        case title
        case imagePath = "image_path"
        case cookingTime = "cooking_time"
        case ingredients
        case instructions
        case creationDate = "creation_date"
    }
}

struct Ingredient {
    var name: String
    var quantity: String? = nil
    var unit: String? = nil
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

struct RecipeData {
    var name: String
    var imagePath: String? // Assuming you'll have an image URL after uploading to Cloudinary
    var cookingTime: String
    var ingredients: String
    var instructions: String
    var creationDate: String // Format as needed, e.g., "YYYY-MM-DD HH:mm:ss"
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
