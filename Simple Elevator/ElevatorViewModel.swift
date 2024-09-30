//
//  ElevatorViewModel.swift
//  Simple Elevator
//
//  Created by Meet Shah on 29/09/24.
//

import SwiftUI

enum MovementDirection: String {
    case up = "Up"
    case down = "Down"
}

@MainActor
class ElevatorViewModel: ObservableObject {
    @Published var currentFloor: Int = 0
    @Published var shouldMove: Bool = false
    @Published var direction: MovementDirection = .up
    @Published var moveToFloor: String = ""
    var maxFloor: Int = 15
    var minFloor: Int = 0
    
    let singleFloorTimeInterval: TimeInterval = 2
    
    var isMoveDownButtonDisabled: Bool {
        currentFloor == minFloor || shouldMove
    }
    
    var isMoveUpButtonDisabled: Bool {
        currentFloor == maxFloor || shouldMove
    }
    
    var isGoButtonDisabled: Bool {
        let floorInt = Int(moveToFloor) ?? 0
        return moveToFloor.isEmpty || floorInt == currentFloor || floorInt > maxFloor || floorInt < minFloor || shouldMove
    }
    
    func move(_ step: Int) {
        if step > 0 && currentFloor == maxFloor {
            return
        } else if step < 0 && currentFloor == minFloor {
            return
        } else {
            direction = step > 0 ? .up : .down
            shouldMove = true
            Timer.scheduledTimer(withTimeInterval: singleFloorTimeInterval, repeats: false) { [weak self] _ in
                self?.shouldMove = false
                withAnimation {
                    self?.currentFloor += step
                }
            }
        }
    }
    
    func moveTo() {
        let floorInt = Int(moveToFloor) ?? 0
        direction = floorInt > currentFloor ? .up : .down
        shouldMove = true
        Timer.scheduledTimer(withTimeInterval: singleFloorTimeInterval, repeats: true) { [weak self] timer in
            withAnimation {
                self?.currentFloor += self?.direction == .up ? 1 : -1
            }
            if self?.currentFloor == floorInt {
                timer.invalidate()
                self?.moveToFloor = ""
                self?.shouldMove = false
            }
        }
    }
}
