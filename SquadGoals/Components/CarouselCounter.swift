//
//  CarouselCounter.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/11/22.
//

import Foundation
import SwiftUI

struct CarouselCounter: View {
    var count : Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .strokeBorder(.white,lineWidth: 1)
                .background(Circle().foregroundColor(.white))
                .frame(width: 8, height: 8)
            
            Circle()
                .strokeBorder(.white,lineWidth: 1)
                .background(Circle().foregroundColor(count > 1 ? .white : .clear))
                .frame(width: 8, height: 8)
            
            Circle()
                .strokeBorder(.white,lineWidth: 1)
                .background(Circle().foregroundColor(count > 2 ? .white : .clear))
                .frame(width: 8, height: 8)
            
            Circle()
                .strokeBorder(.white,lineWidth: 1)
                .background(Circle().foregroundColor(count > 3 ? .white : .clear))
                .frame(width: 8, height: 8)
        }
    }
}
