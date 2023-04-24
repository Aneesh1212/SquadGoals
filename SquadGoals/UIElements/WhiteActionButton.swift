
import Foundation
import SwiftUI

struct BlueActionButton : View {
    
    var text : String
    
    var body : some View {
        Text(text)
            .foregroundColor(.white)
            .font(.system(size: 16))
            .frame(height: 40, alignment: .center)
            .frame(maxWidth: .infinity)
            .background(Colors.buttonBlue)
            .cornerRadius(15)
    }
    
}
