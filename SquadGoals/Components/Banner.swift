//
//  Banner.swift
//  BannersSwiftUI
//
//  Created by Jean-Marc Boullianne on 11/30/19.
//  Copyright © 2019 Jean-Marc Boullianne. All rights reserved.
//
import SwiftUI

struct BannerModifier: ViewModifier {
    
    
    // Members for the Banner
    var user : User
    @Binding var show:Bool
    var backgroundColor : Color
    @State var navigateToReflection = false
    
    func body(content: Content) -> some View {
        
        NavigationLink(destination: SundayReflection(user: self.user), isActive: $navigateToReflection) { EmptyView() }
        
        
        VStack(spacing: 0) {
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Congrats on the week!")
                                .bold()
                            Text("Click here to visit the Sunday Reflections page to create your new weekly goals")
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color(red: 67/255, green: 154/255, blue: 215/255))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    self.navigateToReflection = true
                }
            }
            if show {
                content
                    .overlay(Color.gray.opacity(0.6))
            } else {
                content
            }
        }
        .background(backgroundColor)
    }
    
}

extension View {
    func banner(user : User, show: Binding<Bool>, color: Color) -> some View {
        self.modifier(BannerModifier(user: user, show: show, backgroundColor: color))
    }
}
