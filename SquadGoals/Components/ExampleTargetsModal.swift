//
//  ExampleTargetsModal.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 7/18/22.
//
import SwiftUI
import Foundation
import UIKit

struct ExampleTargetsModal: View {
    
    @Binding var shown: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .padding(.top, 4)
                    .foregroundColor(Colors.blueText)
            }
            .padding(.horizontal, 8)
            
            Image(uiImage: UIImage(named: "Tutorial2")!)
                .resizable()
                .padding(.horizontal, 4)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height * 0.5)
        .background(Colors.lightOrangeBackground)
        .clipped()
        .border(Colors.blueText, width: 2)
        .onTapGesture {
            shown.toggle()
        }
    }
}
