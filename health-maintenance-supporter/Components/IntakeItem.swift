//
//  IntakeItem.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//


import SwiftUI

struct IntakeItem:View {
    let name: String
        let calCount: Int
        let grams: Int
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.appText)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 2) {
                            Text("\(calCount)")
                                .font(.subheadline.bold())
                            Text("kcal")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 2) {
                            Text("\(grams)")
                                .font(.subheadline.bold())
                            Text("g")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    // Delete action
                } label: {
                    Image(systemName: "xmark.bin.fill")
                        .foregroundColor(.red)
                }
            }
            .frame(height: 45)
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
}

