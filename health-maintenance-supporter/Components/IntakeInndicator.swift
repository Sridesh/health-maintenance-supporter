//
//  IntakeInndicator.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI

struct IntakeIndicator: View {
    var name: String
    var intake: Int
    var fullAmount: Int
    var color: Color
    
    var progress : Double {
        if fullAmount <= 0 {return 0}
        return Double(intake)/Double(fullAmount)
    }

    var body: some View {
        VStack{
            HStack{
                Text(name).font(.system(size: 10))
                Spacer()
                Text("\(intake)/\(fullAmount)g").foregroundColor(.gray).font(.system(size: 10))
            }
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame( width: 130,height: 7)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                Rectangle()
                    .frame(width: 130 * CGFloat(progress), height: 7)
                    .foregroundColor(color)
                    .cornerRadius(4)
            }.frame(height: 7)
        }.frame(width:130)
    }
}
// #Preview {
//     IntakeIndicator(name:"Fat", intake: 2, fullAmount: 10, color:Color.blue)
//}
