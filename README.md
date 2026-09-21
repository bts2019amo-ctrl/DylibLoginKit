# DylibLoginKit

Biblioteca nativa iOS em Swift com uma tela de login UIKit reutilizável, cliente de autenticação substituível e armazenamento de sessão no Keychain.

> **Nota de arquitetura:** para iOS, a forma adequada de distribuir uma biblioteca para um aplicativo autorizado é `framework` ou `xcframework`. Um `.dylib` isolado não é uma tela instalável e não deve ser injetado em aplicativos de terceiros. O projeto foi preparado para integração legítima em um app seu.

## Requisitos

- Xcode 15 ou mais recente
- iOS 15+
- Swift 5.9+

## Abrir no Xcode

1. Copie a pasta `DylibLoginKit` para o Mac.
2. Abra o arquivo `Package.swift` no Xcode.
3. Selecione o scheme `DylibLoginKit` e um simulador iOS.
4. Integre o pacote ao seu aplicativo pelo menu **File > Add Package Dependencies > Add Local**.

## Exibir a tela

```swift
import DylibLoginKit

let login = LoginViewController(authClient: DemoAuthClient()) { session in
    print("Sessão: \(session.token)")
}

let navigation = UINavigationController(rootViewController: login)
window?.rootViewController = navigation
window?.makeKeyAndVisible()
```

As credenciais demonstrativas são:

- E-mail: `demo@example.com`
- Senha: `123456`

Essa implementação é somente para teste visual. Ela não chama uma API real.

## Trocar pela API real

Quando a documentação estiver disponível, será criada uma implementação de `AuthClient` usando `URLSession`, com:

- URL e método do endpoint;
- formato JSON do request e response;
- tratamento de HTTP 4xx/5xx;
- validação de TLS e erros de rede;
- token armazenado no Keychain;
- logout e expiração de sessão.

Não coloque chaves privadas, tokens de produção ou senhas dentro do repositório.

## Build de distribuição

Depois de integrar ao seu aplicativo e configurar a assinatura no Xcode, gere um `xcframework` para os destinos necessários. A assinatura e instalação devem ser feitas somente para o aplicativo e a conta de desenvolvimento autorizados.
