//
//  Simple_ElevatorTests.swift
//  Simple ElevatorTests
//
//  Created by Meet Shah on 29/09/24.
//

import XCTest
@testable import Simple_Elevator

@MainActor
final class Simple_ElevatorTests: XCTestCase {
    var viewModel: ElevatorViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = ElevatorViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.currentFloor, 0)
        XCTAssertEqual(viewModel.shouldMove, false)
    }

    @MainActor
    func testMoveUp() {
        viewModel.currentFloor = 0
        viewModel.move(1)
        let exp = expectation(description: "Test after \(viewModel.singleFloorTimeInterval) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: viewModel.singleFloorTimeInterval)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentFloor, 1)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    @MainActor
    func testMoveDown() {
        viewModel.currentFloor = 1
        viewModel.move(-1)
        let exp = expectation(description: "Test after \(viewModel.singleFloorTimeInterval) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: viewModel.singleFloorTimeInterval)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentFloor, 0)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    @MainActor
    func testMinMove() {
        viewModel.currentFloor = viewModel.minFloor
        viewModel.move(-1)
        let exp = expectation(description: "Test after \(viewModel.singleFloorTimeInterval) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: viewModel.singleFloorTimeInterval)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentFloor, viewModel.minFloor)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    @MainActor
    func testMaxMove() {
        viewModel.currentFloor = viewModel.maxFloor
        viewModel.move(1)
        let exp = expectation(description: "Test after \(viewModel.singleFloorTimeInterval) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: viewModel.singleFloorTimeInterval)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentFloor, viewModel.maxFloor)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    @MainActor
    func testMoveToFloorUp() {
        let targetFloor: Int = 4
        viewModel.moveToFloor = "\(targetFloor)"
        viewModel.currentFloor = 0
        viewModel.moveTo()
        let exp = expectation(description: "Test after \(viewModel.singleFloorTimeInterval * Double(targetFloor - viewModel.currentFloor)) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: viewModel.singleFloorTimeInterval * Double(targetFloor - viewModel.currentFloor))
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentFloor, targetFloor)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    @MainActor
    func testMoveToFloorDown() {
        let targetFloor: Int = 2
        viewModel.moveToFloor = "\(targetFloor)"
        viewModel.currentFloor = 4
        viewModel.moveTo()
        let exp = expectation(description: "Test after \(viewModel.singleFloorTimeInterval * Double(viewModel.currentFloor - targetFloor)) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: viewModel.singleFloorTimeInterval * Double(viewModel.currentFloor - targetFloor))
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.currentFloor, targetFloor)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testDisabledButtons() {
        viewModel.currentFloor = viewModel.minFloor
        XCTAssertTrue(viewModel.isMoveDownButtonDisabled)
        
        viewModel.currentFloor = viewModel.maxFloor
        XCTAssertTrue(viewModel.isMoveUpButtonDisabled)
        
        viewModel.moveToFloor = ""
        XCTAssertTrue(viewModel.isGoButtonDisabled)
        
        viewModel.moveToFloor = "1"
        viewModel.shouldMove = true
        XCTAssertTrue(viewModel.isMoveUpButtonDisabled)
        XCTAssertTrue(viewModel.isMoveDownButtonDisabled)
        XCTAssertTrue(viewModel.isGoButtonDisabled)
    }
}
