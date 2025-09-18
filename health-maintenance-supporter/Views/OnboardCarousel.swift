//
//  OnboardCarousel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-18.
//

import SwiftUI

struct CarouselItems  {
    var id: Int
    var description: String
    var heading: String
}

struct OnboardCarouselView: View {
    private var items: [CarouselItems] = ItemsList
    @State private var currentIndex = 0
    
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Image display
            HStack{
                Button(action: {                    
                    userViewModel.updateUserOnboarding()
                }) {
                    HStack {
                        Text("Skip")
                        Image(systemName: "chevron.right")
                        
                    }.foregroundColor(.white)
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(50)
                }
            }.frame(maxWidth: .infinity, alignment: .trailing)
            
            
            VStack(spacing: 10) {
                            if !items.isEmpty {
                                Image("screen\(items[currentIndex].id)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 480)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                
                                Text(items[currentIndex].heading)
                                    .font(.title2)
                                    .bold()
                                
                                Text(items[currentIndex].description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            } else {
                                Text("No items available")
                            }
                        }
                        .frame(maxHeight: .infinity)
        
            
            //navigation buttons
            HStack {
                Button(action: {
                    if currentIndex > 0 {
                            currentIndex -= 1
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }.foregroundColor(.white)
                        .padding()
                        .background(Color.appSecondary)
                        .cornerRadius(10)
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button(action: {
                    if currentIndex < items.count - 1 {
                        currentIndex += 1
                    }
                }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }.foregroundColor(.white)
                        .padding()
                        .background(Color.appSecondary)
                        .cornerRadius(10)
                }
                .disabled(currentIndex == items.count - 1)
            }
            .padding(.horizontal, 40)
            
            //progress bar
            if currentIndex == items.count - 1{
                Button("Finish"){
                    userViewModel.updateUserOnboarding()
                }.foregroundColor(.white)
                    .padding()
                    .background(Color.appGreen)
                    .cornerRadius(10)
            } else {
                ProgressView(value: Double(currentIndex + 1), total: Double(items.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.appPrimary))
                    .padding(.horizontal)
                    .padding(.top, 20)
            }
            
        }
        .animation(.easeInOut, value: currentIndex)
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.appSecondary.opacity(0.2))
    }
}

private var ItemsList : [CarouselItems] = [
    CarouselItems(id: 1, description: "View all you progress for today", heading: "Dashboard"),
    CarouselItems(id: 2, description: "Update your meal and water intake", heading: "Update Intakes"),
    CarouselItems(id: 3, description: "You can either log your food by searching or using our AI food identifying feature", heading: "Log foods"),
    CarouselItems(id: 4, description: "Our cutting edge AI food identifier has a high accurcy rate close to 99%", heading: "AI Food Identification"),
    CarouselItems(id: 5, description: "Choose the size of your serving and log the food", heading: "Food Item Details"),
    CarouselItems(id: 6, description: "Track you activity for today", heading: "Activities Tracking"),
    CarouselItems(id: 7, description: "Update other task completions", heading: "Tasks"),
    CarouselItems(id: 8, description: "Keep Track of your progress so far", heading: "Progress Insights"),
]

#Preview(body: {
    OnboardCarouselView()
})
