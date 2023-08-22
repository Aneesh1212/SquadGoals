
import Foundation
import SwiftUI

struct BlueActionButton : View {
    
    var text : String
    var action : () -> Void
    var height: CGFloat?
    
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .frame(height: height ?? 45, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Colors.buttonBlue)
                .cornerRadius(10)
        })
    }
}
