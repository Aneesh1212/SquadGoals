//
//  ContentView.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 1/6/22.
//
import SwiftUI
                    
                    
struct ContentView: View {
    @StateObject var userSession = UserSession()

    var body: some View {
        NavigationView{
            Welcome(shouldTryToSignIn: true)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .environmentObject(userSession)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}

protocol GestureRecognizerInteractor: AnyObject {
  func addKeyboardDismissGestureRecognizer() -> UIGestureRecognizer?
  func removeGestureRecognizer(_ gesture: UIGestureRecognizer)
}

extension UIApplication: GestureRecognizerInteractor {
  func addKeyboardDismissGestureRecognizer() -> UIGestureRecognizer? {
    guard let window = windows.first else { return nil }
    let tapGesture = KeyboardTapDismissGestureRecognizer(target: window,
                                                         action: #selector(UIView.endEditing))
    tapGesture.requiresExclusiveTouchType = false
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    window.addGestureRecognizer(tapGesture)
    return tapGesture
  }

  func removeGestureRecognizer(_ gesture: UIGestureRecognizer) {
    guard let window = windows.first else { return }
    window.removeGestureRecognizer(gesture)
  }
}

extension UIApplication: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

final class KeyboardTapDismissGestureRecognizer: UIGestureRecognizer {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touchedView = touches.first?.view else {
      state = .began
      return
    }

    // If the tap is on an interactive element
    // cancel the recognizer so tap is forwarded to UI element
    if let textView = touchedView as? UITextView {
      state = textView.isEditable ? .cancelled : .began
    } else {
      state = touchedView is UIControl ? .cancelled : .began
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    state = .ended
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .cancelled
  }
}
