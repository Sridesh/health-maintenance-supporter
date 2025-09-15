import SwiftUI

struct FitnessListView: View {
    @State private var selectedPlan: FitnessPlan? = nil
    let isInside : Bool
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(fitnessPlans, id: \.id) { plan in
                        Button {
                            selectedPlan = plan
                            userViewModel.openModal = true
                        } label: {
                            FitnessCard(plan: plan)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $userViewModel.openModal) {
                if let plan = selectedPlan {
                    FitnessDetailView(plan: plan, isInsideApp: isInside)
                        .environmentObject(userViewModel)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }

        }
    }
}

struct FitnessCard: View {
    let plan: FitnessPlan
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient card
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [Color.appPrimary.opacity(0.7), Color.appSecondary.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 8)
            
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(plan.goal)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                
                // Description
                Text(plan.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(3)
                
                // Quick stats
                HStack(spacing: 12) {
                    StatChip(icon: "flame.fill", value: "\(plan.dailyTargets.calories) cal", color: Color.white)
                    StatChip(icon: "figure.walk", value: "\(plan.dailyTargets.steps) steps",color: Color.white)
                    StatChip(icon: "drop.fill", value: "\(String(format: "%.1f", plan.dailyTargets.water))L",color: Color.white)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 180)
    }
}

struct StatChip: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color.appText)
            Text(value)
                .font(.caption)
                .foregroundStyle(Color.appText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
    }
}

struct FitnessDetailView: View {
    let plan: FitnessPlan
    let isInsideApp: Bool
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.appPrimary.opacity(0.33), Color.appSecondary.opacity(0.20)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Hero Title
                    Text(plan.goal)
                        .font(.largeTitle.bold())
                        .foregroundStyle(
                            LinearGradient(colors: [Color.appPrimary,Color.appPrimary], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    Text(plan.description)
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    // Daily Targets
                    GlassCard{
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Daily Targets")
                                .font(.headline)
                            
                            HStack {
                                StatChip(icon: "flame.fill", value: "\(plan.dailyTargets.calories) cal", color:Color.appSecondary)
                                StatChip(icon: "drop.fill", value: "\(String(format: "%.1f", plan.dailyTargets.water)) L",color:Color.appSecondary)
                            }
                            
                            HStack {
                                StatChip(icon: "fork.knife", value: "P: \(plan.dailyTargets.macros.protein)g",color:Color.appSecondary)
                                StatChip(icon: "leaf", value: "C: \(plan.dailyTargets.macros.carbs)g",color:Color.appSecondary)
                                StatChip(icon: "circle.lefthalf.fill", value: "F: \(plan.dailyTargets.macros.fats)g",color:Color.appSecondary)
                            }
                            
                            HStack {
                                StatChip(icon: "figure.walk", value: "\(plan.dailyTargets.steps) steps",color:Color.appSecondary)
                                StatChip(icon: "ruler", value: "\(plan.dailyTargets.distance) km",color:Color.appSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Special Targets
                    GlassCard{
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Special Targets")
                                .font(.headline)
                            
                            ForEach(plan.specialTargets.keys.sorted(), id: \.self) { key in
                                HStack {
                                    Text(key.replacingOccurrences(of: "_", with: " ").capitalized)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(String(describing: plan.specialTargets[key]!))")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                        
                    }
                    
                    Button("Select This"){
                        userViewModel.currentUser.goalId = plan.id
                        userViewModel.openModal = false
                        
                        if isInsideApp {
                            userViewModel.updateUserGoal(goalId: plan.id)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.appPrimary)
                    .foregroundColor(.white)
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct FitnessListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitnessListView()
//    }
//}
//
//struct FitnessDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitnessDetailView(plan: fitnessPlans.first!)
//    }
//}
