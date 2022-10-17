import Foundation
import SwiftUI

struct OnboardingActionButton : View {
    var action : () -> Void
    var text: String
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .frame(width: 250, height: 40, alignment: .center)
                .background(Colors.blueText)
                .cornerRadius(15)
                .shadow(radius: 10)
        })
    }
}
