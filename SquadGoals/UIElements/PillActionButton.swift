

import Foundation
import SwiftUI

struct PillActionButton : View {
    
    var text : String
    var icon: String?
    var foregroundColor : Color
    var backgroundColor: Color
    
    var body : some View {
        
        HStack(spacing: 0){
            if (icon != nil) {
                Label ("", systemImage: icon!)
                    .foregroundColor(foregroundColor)
            }
            Text(text)
                .foregroundColor(foregroundColor)
                .opacity(1.0)
                .font(.system(size: 14))
        }
        .frame(height: 30, alignment: .center)
        .padding(.horizontal, 8)
        .background(backgroundColor)
        .cornerRadius(15)
    }
}
