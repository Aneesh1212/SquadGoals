
import Foundation
import SwiftUI

struct GreenActionButton : View {
    
    var text : String
    var action : () -> Void
    var height: CGFloat?
    var textColor: Color?

    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(textColor ?? .black)
                .font(.system(size: 16))
                .frame(height: height ?? 45, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Colors.buttonGreen)
                .cornerRadius(10)
        })
    }
}
