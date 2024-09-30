//
//  ContentView.swift
//  Simple Elevator
//
//  Created by Meet Shah on 29/09/24.
//

import SwiftUI

struct ContentView: View {
    enum Constants {
        static var navTitle = "Simple Elevator"
        static var currentFloor = "Current Floor"
        static var moveUp: String = "Move Up"
        static var moveDown: String = "Move Down"
        static var enterFloor = "Enter Floor"
        static var go = "Go"
        static var startPosition: CGFloat = -40
        static var endPosition: CGFloat = 0
    }
    
    @StateObject var elevatorVM: ElevatorViewModel = ElevatorViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(Constants.currentFloor)
                    .font(.title)
                Text("\(elevatorVM.currentFloor)")
                    .contentTransition(.numericText(countsDown: elevatorVM.direction == .down))
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 50)
                if elevatorVM.direction == .up {
                    MovementAnimationView(direction: .up, startPosition: Constants.startPosition, endPosition: Constants.endPosition)
                        .isHidden(!elevatorVM.shouldMove)
                } else {
                    MovementAnimationView(direction: .down, startPosition: Constants.endPosition, endPosition: Constants.startPosition)
                        .isHidden(!elevatorVM.shouldMove)
                }
                VStack {
                    HStack(spacing: 30) {
                        Button {
                            elevatorVM.move(1)
                        } label: {
                            Text(Constants.moveUp)
                                .padding(8)
                        }
                        .disabled(elevatorVM.isMoveUpButtonDisabled)
                        .buttonStyle(.bordered)
                        .background(Color.indigo)
                        .opacity(elevatorVM.isMoveUpButtonDisabled ? 0.5 : 1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .font(.body)
                        .bold()
                        
                        Button {
                            elevatorVM.move(-1)
                        } label: {
                            Text(Constants.moveDown)
                                .padding(8)
                        }
                        .disabled(elevatorVM.isMoveDownButtonDisabled)
                        .buttonStyle(.bordered)
                        .background(Color.indigo)
                        .opacity(elevatorVM.isMoveDownButtonDisabled ? 0.5 : 1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .font(.body)
                        .bold()
                    }
                    HStack(spacing: 20) {
                        TextField(Constants.enterFloor, text: $elevatorVM.moveToFloor)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.plain)
                            .padding(.leading)
                            .frame(width: 200, height: 44)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Button(action: {
                            self.endEditing()
                            elevatorVM.moveTo()
                        }, label: {
                            Text(Constants.go)
                        })
                        .disabled(elevatorVM.isGoButtonDisabled)
                        .frame(width: 70, height: 44)
                        .buttonStyle(.bordered)
                        .background(Color.indigo)
                        .opacity(elevatorVM.isGoButtonDisabled ? 0.5 : 1)
                        .foregroundStyle(.white)
                        .font(.body)
                        .bold()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .modifier(KeyboardAdaptive(padding: 60))
                    .padding(.horizontal)
                    .padding(.top, 30)
                }
                .padding(.top, 30)
                .disabled(elevatorVM.shouldMove)
                .opacity(elevatorVM.shouldMove ? 0.5 : 1)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 50)
            .background(Color.yellow)
            .navigationTitle(Constants.navTitle)
        }
    }
}

#Preview {
    ContentView()
}
