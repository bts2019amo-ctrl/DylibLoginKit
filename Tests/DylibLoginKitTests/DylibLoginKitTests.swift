import XCTest
@testable import DylibLoginKit

final class DylibLoginKitTests: XCTestCase {
    func testDemoLoginAcceptsDemoCredentials() async throws {
        let session = try await DemoAuthClient().login(
            LoginCredentials(email: "demo@example.com", password: "123456")
        )
        XCTAssertEqual(session.token, "demo-session-token")
    }

    func testDemoLoginRejectsOtherCredentials() async {
        do {
            _ = try await DemoAuthClient().login(
                LoginCredentials(email: "other@example.com", password: "wrong")
            )
            XCTFail("Expected invalid credentials")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidCredentials)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
