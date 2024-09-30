//
//  KeyboardResponder.swift
//  Simple Elevator
//
//  Created by Meet Shah on 29/09/24.
//

import Combine
import SwiftUI

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    init() {
        keyboardWillShowNotification.map { notification in
            CGFloat((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
        }
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)

        keyboardWillHideNotification.map { _ in
            CGFloat(0)
        }
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)
    }

    private var cancellableSet: Set<AnyCancellable> = []
}

let keyboardResponder = KeyboardResponder()

struct KeyboardAdaptive: ViewModifier {
    @ObservedObject private var keyboard = keyboardResponder
    var padding: CGFloat?

    func body(content: Content) -> some View {
        content
            .padding(.bottom, padding ?? keyboard.currentHeight)
    }
}
