//
//  ProgressBar.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/22/21.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    var progressValue : Float
    var weekPercentage : Float
    var text : String
    var isLargeVersion : Bool
    
    var body: some View {
        let progressColor = (progressValue >= weekPercentage) ? Color.green : (progressValue >= weekPercentage / 2 ? Color.yellow : Color.red)
        
        ZStack {
            Circle()
                .stroke(lineWidth: isLargeVersion ? 7.0 : 6.0)
                .foregroundColor(Colors.progressBarBackground)
            
            /* Circle()
                .trim(from: 0.0, to: CGFloat(weekPercentage))
                .stroke(style: StrokeStyle(lineWidth: isLargeVersion ? 8.0 : 6.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Colors.progressBarBackground)
                .rotationEffect(Angle(degrees: 90.0))
             */
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progressValue))
                .stroke(style: StrokeStyle(lineWidth: isLargeVersion ? 8.0 : 6.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: 90.0))
            
            Subtitle(text: text, size: isLargeVersion ? 18.0 : 16)
        }
    }
}
