//
//  Subtitle.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct SubtitleV2 : View {
    
    var text : String
    
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .regular))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
