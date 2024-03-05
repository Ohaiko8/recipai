import SwiftUI

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
