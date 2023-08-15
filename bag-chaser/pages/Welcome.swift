//
//  welcome.swift
//  bag-chaser
//
//  Created by Raphael Lim on 14/8/23.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) ).ignoresSafeArea()
    }
}

struct Welcome: View {
    var Screen_Height = UIScreen.main.bounds.height
    var Screen_Width = UIScreen.main.bounds.width
    
    @Binding var showWelcomeScreen: Bool
    
    var body: some View {
        ZStack{
            VStack{
                Color.theme.accent
                    .frame(maxHeight: Screen_Height/3)
                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                
                Spacer()
                
                Button(action: {
                    showWelcomeScreen.toggle()
                    print(showWelcomeScreen)
                }, label: {
                    Text("Continue")
                        .frame(width: 280, height: 50)
                        .background(Color.theme.accent)
                        .foregroundColor(Color.theme.buttonText)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .cornerRadius(10)
                }).padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                
            }
                
            VStack{
                Spacer()
                Text("🌱")
                    .font(.system(size: 96))
                Text("Money Plant")
                    .font(.system(size: 42, weight: .semibold, design: .default))
                Text("Your Daily Finance Tracker")
                    .font(.system(size: 18, weight: .light, design: .default))
                    .foregroundColor(Color.theme.text)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -200, trailing: 0))
                
                Spacer()
                
                TabView{
                    Text("No signups required")
                    Text("Minimal")
                    Text("For the busy")
                }.tabViewStyle(.page).background(Color.theme.accent).frame(maxHeight: 120).foregroundColor(Color.theme.buttonText).font(.system(size: 24, weight: .medium, design: .default))
                
            }.frame(maxWidth: Screen_Width/1.2, maxHeight: Screen_Height/1.5)
                .background(Color.theme.card)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 10)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background)
        .ignoresSafeArea()
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome(showWelcomeScreen: .constant(true))
    }
}
