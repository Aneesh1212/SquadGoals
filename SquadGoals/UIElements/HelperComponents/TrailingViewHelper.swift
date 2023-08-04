

import Foundation
import SwiftUI

struct TrailingViewHelper : View {
    
    var view : AnyView
    
    var body : some View {
        
        HStack {
            Spacer()
            view
        }
    }
}
