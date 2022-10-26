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
    
    var body: some View {
        let progressColor = (progressValue >= weekPercentage) ? Color.green : (progressValue >= weekPercentage / 2 ? Color.yellow : Color.red)
        
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .foregroundColor(.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(weekPercentage))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Colors.progressBarBackground)
                .rotationEffect(Angle(degrees: 90.0))

            
            Circle()
                .trim(from: 0.0, to: CGFloat(progressValue))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: 90.0))
            
            Text(text)
                .font(.system(size:22))
                .foregroundColor(Colors.blueText)
        }
    }
}
