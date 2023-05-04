//
//  Title.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 1/9/22.
//

import Foundation
import SwiftUI

struct TitleV2 : View {
    
    var text : String
    var lineLimit : Int?
    var size : CGFloat?
    var shouldLeftAlign: Bool?
    
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: size ?? 24, weight: .semibold))
                .minimumScaleFactor(0.85)
                .lineLimit(lineLimit ?? 1)
                .multilineTextAlignment(shouldLeftAlign ?? false ? .leading : .center)
        }
    }
}
