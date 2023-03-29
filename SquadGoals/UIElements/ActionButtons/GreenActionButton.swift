
import Foundation
import SwiftUI

struct GreenActionButton : View {
    
    var text : String
    var action : () -> Void
    
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: 16))
                .frame(height: 45, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Colors.buttonGreen)
                .cornerRadius(15)
        })
    }
}
