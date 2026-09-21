import Foundation

public struct LoginCredentials: Sendable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginSession: Sendable {
    public let token: String

    public init(token: String) {
        self.token = token
    }
}

public enum AuthError: LocalizedError, Sendable {
    case invalidCredentials
    case invalidResponse
    case unavailable

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "E-mail ou senha inválidos."
        case .invalidResponse: return "Resposta inválida do servidor."
        case .unavailable: return "Serviço indisponível."
        }
    }
}

public protocol AuthClient: Sendable {
    func login(_ credentials: LoginCredentials) async throws -> LoginSession
}

/// Implementação apenas para teste visual local. Remova antes de produção.
public struct DemoAuthClient: AuthClient {
    public init() {}

    public func login(_ credentials: LoginCredentials) async throws -> LoginSession {
        try await Task.sleep(nanoseconds: 450_000_000)
        guard credentials.email == "demo@example.com", credentials.password == "123456" else {
            throw AuthError.invalidCredentials
        }
        return LoginSession(token: "demo-session-token")
    }
}
