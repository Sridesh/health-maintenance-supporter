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
        "Apple", "Banana", "Orange", "Dragon Fruit", "Mango", "Pineapple", "Papaya", "Cherry"
    ]

    var filteredFoods: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return allFoods.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.orange)
                    .padding(.leading, 8)

                TextField("Search food...", text: $searchText)
                    .padding(10)
                    .background(Color.appWhiteText.opacity(0.3))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                if !searchText.isEmpty {
                    Button(action: { 
                        searchText = ""
                        foodItemViewModel.searching = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.appSecondary)
                    }
                    .padding(.trailing, 8)
                }
            }
            
            
            if !searchText.isEmpty { //show results only if there is text
                VStack(spacing: 0) {
                    ForEach(filteredFoods, id: \.self) { food in
                        NavigationLink(destination: FoodItemDetails(portionSize: 200.00)
                                        .onAppear {
                                            foodItemViewModel.changeSelectedFood(food: food)
                                        }) {
                            HStack {
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.appSecondary)
                                Text(food)
                                    .font(.headline)
                                    .foregroundColor(Color.appText)
                                Spacer()
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                            .background(Color.appWhiteText.opacity(0.1))
                        }
                    }
                }
                .onAppear{
                    foodItemViewModel.searching = true
                }.onDisappear{
                    foodItemViewModel.searching = false
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.appWhiteText.opacity(0.1)))
                .padding(.horizontal)
            }
        }
    }
}

//
//#Preview {
//    FoodSearch()
//}


