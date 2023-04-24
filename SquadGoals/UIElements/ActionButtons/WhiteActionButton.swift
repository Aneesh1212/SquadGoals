
import Foundation
import SwiftUI

struct WhiteActionButton : View {
    
    var text : String
    var action : () -> Void
    
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .medium))
                .frame(height: 45, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(15)
        })
    }
}
