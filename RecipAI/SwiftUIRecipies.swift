import SwiftUI

struct AppGradient {
    static let background = LinearGradient(gradient: Gradient(colors: [Color.customLightOrange, Color.customOrange, Color.customDarkOrange]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

struct RecipeListView: View {
    let recipes = ["Spaghetti Carbonara", "Classic Burger", "Vegetarian Pizza"]

    var body: some View {
        NavigationView {
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all) // Set a soft background color
                
                ScrollView {
                    ForEach(recipes, id: \.self) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeName: recipe)) {
                            RecipeCardView(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove button effects to make it look more like a card
                    }
                }
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.large)
                .background(Color.clear)
            }
        }
        .accentColor(.customDarkOrange) // Customize navigation bar items color
    }
}

struct RecipeDetailView: View {
    let recipeName: String

    var body: some View {
        ZStack {
            AppGradient.background.edgesIgnoringSafeArea(.all)
            Text(recipeName)
                .font(.title)
                .foregroundColor(.offWhite)
        }
        .navigationTitle(recipeName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeCardView: View {
    var recipe: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(AppGradient.background)
                .shadow(radius: 5)
            Text(recipe)
                .font(.headline)
                .foregroundColor(.offWhite)
                .padding()
        }
        .frame(height: 100)
        .padding(.horizontal)
    }
}
