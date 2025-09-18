import SwiftUI
import SwiftData

struct AddMeal: View {
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add a food item").font(.title3).bold().foregroundColor(.appPrimary).frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                    VStack{
                        Text("Manually search for food").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                        FoodSearch()
                            .environmentObject(foodItemViewModel)
                            .padding(.bottom)
                    }
   
                if !foodItemViewModel.searching {
                    VStack{
                        Divider()
                            .padding(.vertical)
                            .foregroundColor(Color.appPrimary)
                        
                        VStack{
                            Text("Identify nutritions with AI").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                NavigationLink(destination: CameraClassificationView().environmentObject(foodItemViewModel)) {
                                    VStack {
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:40)
                                            .foregroundColor(Color.appPrimary)
                                            .padding(.bottom)
                                        Text("Take Photo").foregroundColor(Color.appPrimary).bold()
                                    }
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.appWhiteText)
                                    .cornerRadius(10)
                                    .shadow(color: Color.appBackgound, radius: 10)
                                    .padding(.trailing)
                                }
                                NavigationLink(destination: ClassificationWithVisionView().environmentObject(foodItemViewModel)){
                                    VStack {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:40)
                                            .foregroundColor(Color.appPrimary)
                                            .padding(.bottom)
                                        Text("Upload Photo").foregroundColor(Color.appPrimary).bold()
                                    }
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.appWhiteText)
                                    .cornerRadius(10)
                                    .shadow(color: Color.appPrimary.opacity(0.2), radius: 10)
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.top)
                            .foregroundColor(Color.appPrimary)
                        
                        VStack{
                            Text("Recent")
                                .padding(10)
                                .background(Color.appSecondary)
                                .foregroundColor(.appWhiteText)
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
                                    .foregroundColor(.appSecondary).bold()
                            }.padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .background(Color.appSecondary.opacity(0.3))
        }
        .navigationTitle("Lecturer Meetings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
