//
//  Search.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-09.
//

import SwiftUI

struct FoodSearch: View {
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    @State private var searchText = ""
    
    let allFoods : [String] = [
        "Apple", "Banana", "Chicken Breast", "Oatmeal", "Greek Yogurt",
        "Salmon", "Broccoli", "Rice", "Eggs", "Almonds",
        "Avocado", "Spinach", "Sweet Potato", "Tofu", "Quinoa"
    ]
    
    var filteredFoods: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return allFoods.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Beautiful search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.orange)
                    .padding(.leading, 8)
                TextField("Search food...", text: $searchText)
                    .padding(10)
                    .background(Color.clear)
                    .foregroundColor(.primary)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                if !searchText.isEmpty {
                    Button(action: {
                        withAnimation { searchText = "" }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                    .transition(.scale)
                }
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appPrimary.opacity(0.1))
                    .shadow(color: Color.orange.opacity(0.15), radius: 6, x: 0, y: 2)
            )
            .animation(.easeInOut, value: searchText)
            
            // Only show the list if searching
            if !searchText.isEmpty {
                List(filteredFoods, id: \.self) { food in
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(Color.appSecondary)
                        Text(food)
                            .font(.headline)
                    }
                    .onTapGesture {
                        foodItemViewModel.changeSelectedFood(food: food)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    FoodSearch()
}

//struct BeautifulSearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        StatefulPreviewWrapper("") { FoodSearch() }
//            .padding()
//            .background(Color(.systemGroupedBackground))
//    }
//}

// Helper for previewing with @Binding
struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ value: Value, content: @escaping (Binding<Value>) -> AnyView) {
        _value = State(wrappedValue: value)
        self.content = content
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> some View) {
        _value = State(wrappedValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}
