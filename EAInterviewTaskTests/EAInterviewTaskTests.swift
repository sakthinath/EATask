//
//  EAInterviewTaskTests.swift
//  EAInterviewTaskTests
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import XCTest
@testable import EAInterviewTask

final class EAInterviewTaskTests: XCTestCase {
     var viewModel: HomeViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
//        Creating an expectation
        let expectation = XCTestExpectation(description: "Fetch band details")
        // Set up the mock service Implementation Class
        let mockService = HttpClientMockProtocol()
        
        viewModel.getbandDetails(homeService: mockService)
        // Wait for the expectation with a timeout
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // Assuming the response is received and viewModel.data is set
                    XCTAssertNotNil(self.viewModel.data)
                    
                    // Fulfill the expectation
                    expectation.fulfill()
                }
                
                // Wait for the expectation to be fulfilled or timeout
                wait(for: [expectation], timeout: 3.0)
    }

}
