
import Foundation
import SwiftUI

struct OrangeActionButton : View {
    
    var text : String
    
    var body : some View {
        Text(text)
            .foregroundColor(.white)
            .font(.system(size: 16))
            .frame(height: 45, alignment: .center)
            .frame(maxWidth: .infinity)
            .background(Colors.darkOrangeForeground)
            .cornerRadius(15)
    }
    
}
