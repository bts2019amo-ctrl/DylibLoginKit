import UIKit

public final class LoginViewController: UIViewController {
    private let authClient: any AuthClient
    private let tokenStore: KeychainTokenStore
    private let onLogin: (LoginSession) -> Void

    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "E-mail"
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.accessibilityIdentifier = "login.email"
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Senha"
        field.isSecureTextEntry = true
        field.borderStyle = .roundedRect
        field.accessibilityIdentifier = "login.password"
        return field
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    public init(
        authClient: any AuthClient,
        tokenStore: KeychainTokenStore = KeychainTokenStore(),
        onLogin: @escaping (LoginSession) -> Void
    ) {
        self.authClient = authClient
        self.tokenStore = tokenStore
        self.onLogin = onLogin
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Entrar"
        configureLayout()
    }

    private func configureLayout() {
        let titleLabel = UILabel()
        titleLabel.text = "Acessar conta"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center

        let subtitle = UILabel()
        subtitle.text = "Entre para continuar"
        subtitle.textColor = .secondaryLabel
        subtitle.textAlignment = .center

        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "login.submit"

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitle, emailField, passwordField, button, statusLabel])
        stack.axis = .vertical
        stack.spacing = 14
        stack.setCustomSpacing(28, after: subtitle)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 48),
            passwordField.heightAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func loginTapped() {
        let credentials = LoginCredentials(
            email: emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            password: passwordField.text ?? ""
        )
        guard !credentials.email.isEmpty, !credentials.password.isEmpty else {
            statusLabel.text = "Preencha e-mail e senha."
            statusLabel.textColor = .systemRed
            return
        }

        statusLabel.text = "Autenticando…"
        statusLabel.textColor = .secondaryLabel
        Task { [weak self] in
            guard let self else { return }
            do {
                let session = try await authClient.login(credentials)
                try tokenStore.save(token: session.token)
                await MainActor.run {
                    self.statusLabel.text = "Login realizado."
                    self.statusLabel.textColor = .systemGreen
                    self.onLogin(session)
                }
            } catch {
                await MainActor.run {
                    self.statusLabel.text = error.localizedDescription
                    self.statusLabel.textColor = .systemRed
                }
            }
        }
    }
}
