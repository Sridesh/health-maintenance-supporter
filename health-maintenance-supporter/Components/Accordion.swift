//
//  Accordion.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-14.
//

import SwiftUI

struct Accordion<Content: View>: View {
    let image: String
    let title: String
    @State private var isExpanded: Bool = true
    let content: Content
    
    init(title: String, image: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.image = image
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(image)
                        .resizable()
                        .frame(width:50, height: 50)
                    Text(title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.appPrimary)
                }
            }
            
            if isExpanded {
                VStack {
                    content
                }
                .padding()
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .cornerRadius(10)

        .padding(.horizontal)
    }
}


#Preview {
    Accordion(title: "String", image: "") {
        VStack{
            Text("Hello")
        }
    }
}
