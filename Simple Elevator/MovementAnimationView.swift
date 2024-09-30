//
//  MovementAnimationView.swift
//  Simple Elevator
//
//  Created by Meet Shah on 29/09/24.
//

import SwiftUI

struct MovementAnimationView: View {
    @State var isAnimating: Bool = false
    var direction: MovementDirection
    var startPosition: CGFloat
    var endPosition: CGFloat
    var body: some View {
        HStack {
            DirectionImageView(isAnimating: isAnimating, direction: direction, startPosition: startPosition, endPosition: endPosition)
            DirectionImageView(isAnimating: isAnimating, direction: direction, startPosition: startPosition, endPosition: endPosition)
            Text("Moving \(direction.rawValue)")
                .font(.title2)
                .offset(y: -20)
                .frame(width: 170)
                .bold()
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .green, .blue]), startPoint: .leading, endPoint: .trailing))
            DirectionImageView(isAnimating: isAnimating, direction: direction, startPosition: startPosition, endPosition: endPosition)
            DirectionImageView(isAnimating: isAnimating, direction: direction, startPosition: startPosition, endPosition: endPosition)
        }
        .padding()
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct DirectionImageView: View {
    var isAnimating: Bool = false
    var direction: MovementDirection
    var startPosition: CGFloat
    var endPosition: CGFloat
    var body: some View {
        Image(systemName: direction == .down ? "arrow.down" : "arrow.up")
            .bold()
            .font(.title2)
            .offset(y: isAnimating ? startPosition : endPosition)
            .animation(isAnimating ? .easeInOut(duration: 1).repeatForever(autoreverses: false) : .default, value: isAnimating)
            .foregroundStyle(
                Color(
                    red: .random(in: 0...1),
                    green: .random(in: 0...1),
                    blue: .random(in: 0...1),
                    opacity: 1
                )
            )
    }
}
