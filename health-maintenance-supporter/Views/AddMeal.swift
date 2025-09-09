import SwiftUI

struct AddMeal: View {
    @State private var searchText = ""
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    
    // Dummy food data
    let allFoods = [
        "Apple",
        "Banana",
        "Chicken Breast",
        "Oatmeal",
        "Greek Yogurt",
        "Salmon",
        "Broccoli",
        "Rice",
        "Eggs",
        "Almonds"
    ]
    
    var filteredFoods: [String] {
        if searchText.isEmpty {
            return allFoods
        } else {
            return allFoods.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
//                TextField("Search foods...", text: $searchText)
//                    .padding(10)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//                    .padding(.top)
//                
//                // Show search results if searching
//                if !searchText.isEmpty {
//                    List(filteredFoods, id: \.self) { food in
//                        Text(food)
//                    }
//                    .frame(height: 200)
//                }
                
                FoodSearch()
                    .environmentObject(foodItemViewModel)
                    .padding(.bottom)
                
                HStack {
                    VStack {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width:40)
                            .foregroundColor(Color.appPrimary)
                            .padding(.bottom)
                        Text("Take Photo")
                    }
                    .padding()
                    .frame(width: 150)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color(hex: "#ff724c").opacity(0.2), radius: 10)
                    .padding(.trailing)
                    
                    VStack {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:40)
                            .foregroundColor(Color.appPrimary)
                            .padding(.bottom)
                        Text("Upload Photo")
                    }
                    .padding()
                    .frame(width: 150)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color(hex: "#ff724c").opacity(0.2), radius: 10)
                }
                
                Divider()
                    .padding(.top)
                
                VStack{
                    Text("Recent")
                        .padding(10)
                        .background(Color.appText)
                        .foregroundColor(.white)
                        .bold()
                        .cornerRadius(50)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack{
                        Image("meal")
                            .padding(.top)
                        Text("No recently added records").bold()
                        Text("Search for what you ate today or upload your meals")
                            .frame(alignment:.center)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                        
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .background(Color(hex: "#fff1ed"))
        }
        .navigationTitle("Lecturer Meetings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
