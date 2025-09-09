//
//  Insights.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import Charts

struct NutritionCount {
  var category: String
  var count: Int
}

let byCategory: [NutritionCount] = [
  .init(category: "Fat", count: 79),
  .init(category: "Protein", count: 73),
  .init(category: "Carbs", count: 58),
  .init(category: "Fiber", count: 15),
  .init(category: "Sugar", count: 9)
]

struct InsightsView: View {
    
    
    var body: some View {
        VStack{
            Text("Insights").font(.headline).padding(.bottom)
            VStack{
                Text("Nutritions").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.blue)
                PieChart(data: byCategory)
            }.frame(width: 250)
                .padding(.bottom, 30)
            
            
            //water intake
            VStack{
                Text("Water Intake").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.blue)
                HStack{
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .frame( width: 130,height: 200
                            )
                            .foregroundColor(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        Rectangle()
                            .frame(width: 130 , height: 200*CGFloat(0.1))
                            .foregroundColor(Color(hex: "#5cb5e1"))
                            .cornerRadius(4)
                        
                        
                        
                        
                    }.frame(height: 200)
                    VStack{
                        HStack{
                            Text("Drank").foregroundColor(Color(hex: "#5b5b5b"))
                            Text("\(2) litres").font(.title2).bold().foregroundColor(Color(hex: "#5b5b5b"))
                        }.frame(width:150, alignment: .leading)
                        HStack{
                            Text("out of").foregroundColor(Color(hex: "#5b5b5b"))
                            Text("\(10) litres").font(.title2).bold().foregroundColor(Color(hex: "#5b5b5b"))}.frame(width:150, alignment: .leading)
                        
                        Text("Next sip in \(12) mins").frame(width:150, alignment: .leading).foregroundColor(Color.green).padding(.top, 30)
                    }
                    
                    
                }
                
            }.frame(width: 250)
                .padding(.bottom, 30)
            
            
            
        }.padding()
            .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    InsightsView()
}
