# Flutter Shopping Cart — MVVM

Aplicativo de carrinho de compras desenvolvido em Flutter como desafio técnico, implementando a arquitetura **MVVM** recomendada pelo time do Flutter. O app consome a [Fake Store API](https://fakestoreapi.com/products), simula operações de carrinho e checkout via `Future.delayed`, e mantém o estado global do carrinho em memória com `ChangeNotifier`.

---

## Sumário

- [Descrição](#descrição)
- [Requisitos](#requisitos)
- [Instalação](#instalação)
- [Execução](#execução)
- [Testes](#testes)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Arquitetura](#arquitetura)
- [Decisões Técnicas](#decisões-técnicas)

---

## Descrição

O app implementa um fluxo completo de compra em três telas:

| Tela | Descrição |
|---|---|
| **Catálogo** | Lista produtos da API com imagem, nome e preço. Permite adicionar ao carrinho e ajustar quantidade diretamente no card. |
| **Carrinho** | Lista os itens com controles de quantidade, remoção individual, resumo do pedido e botão de checkout. |
| **Pedido Finalizado** | Confirma o pedido com resumo de itens, frete e total. Permite iniciar um novo pedido. |

**Regras de negócio implementadas:**
- Máximo de 10 produtos diferentes no carrinho.
- Carrinho finalizado não pode ser editado.
- Todas as operações de API têm 20% de chance de falha aleatória (simulação realista).
- Não é possível voltar ao carrinho após o checkout.

---

## Requisitos

| Ferramenta | Versão mínima |
|---|---|
| Flutter | **3.x** (testado em 3.41.1) |
| Dart | **3.11.0** |
| Android SDK | API 21+ (Android 5.0) |
| Xcode | 14+ (para build iOS) |

Verifique sua versão atual:

```bash
flutter --version
```

---

## Instalação

**1. Clone o repositório:**

```bash
git clone https://github.com/GabrielCairesDev/flutter_carrinho_de_compras.git
cd flutter_carrinho_de_compras
```

**2. Instale as dependências:**

```bash
flutter pub get
```

**3. Verifique o ambiente:**

```bash
flutter doctor
```

---

## Execução

### Android

```bash
# Com um emulador ou dispositivo conectado
flutter run

# Build de release
flutter build apk --release
```

### iOS

```bash
# Instala pods (necessário na primeira vez)
cd ios && pod install && cd ..

# Roda no simulador ou dispositivo
flutter run

# Build de release
flutter build ipa --release
```

### Web

```bash
flutter run -d chrome

# Build de release
flutter build web --release
```

> **Nota:** A API `fakestoreapi.com` pode bloquear requisições CORS no Web. Para desenvolvimento web, considere usar um proxy ou a flag `--web-renderer canvaskit`.

---

## Testes

O projeto conta com **63 testes** organizados em três camadas:

| Camada | Arquivo(s) | Cobertura |
|---|---|---|
| Domínio | `test/domain/` | `Cart`, `CartItem` |
| Dados | `test/data/` | `ProductDto` |
| ViewModels | `test/presentation/` | `CatalogViewModel`, `CartViewModel`, `OrderViewModel` |
| Integração | `test/integration/` | Fluxo completo do usuário |

### Rodar todos os testes

```bash
flutter test
```

### Rodar por categoria

```bash
# Testes unitários de domínio
flutter test test/domain/

# Testes unitários de DTO
flutter test test/data/

# Testes unitários de ViewModels
flutter test test/presentation/

# Testes de integração das telas
flutter test test/integration/
```

### Com output detalhado

```bash
flutter test --reporter expanded
```

### Com cobertura de código

```bash
flutter test --coverage

# Gerar relatório HTML (requer lcov instalado)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Estrutura de Pastas

```
lib/
├── main.dart                        # Ponto de entrada
├── app.dart                         # MaterialApp + tema + rotas
├── routes/
│   └── app_routes.dart              # Definição de rotas nomeadas
│
├── core/                            # Utilitários e widgets reutilizáveis
│   ├── command.dart                 # Padrão Command (Command / Command1)
│   ├── result.dart                  # Tipo sealed Result<T> (Success / Failure)
│   ├── utils/
│   │   └── currency_formatter.dart  # Formatação monetária (BRL)
│   └── widgets/
│       ├── app_snackbar.dart        # SnackBars de sucesso e erro
│       ├── empty_state.dart         # Widget de estado vazio
│       ├── error_state.dart         # Widget de estado de erro
│       ├── loading_state.dart       # Widget de carregamento
│       ├── quantity_counter.dart    # Controle +/− de quantidade
│       └── view_scaffold.dart       # Scaffold que alterna entre loading/erro/vazio/body
│
├── data/                            # Camada de dados (infraestrutura)
│   ├── dtos/
│   │   └── product_dto.dart         # DTO de produto (fromJson + toEntity)
│   └── services/
│       ├── products_api.dart        # GET /products (Fake Store API)
│       ├── cart_api.dart            # Operações de carrinho (simuladas)
│       └── checkout_api.dart        # Checkout (simulado)
│
├── domain/                          # Camada de domínio (entidades puras)
│   └── models/
│       ├── product.dart             # Entidade Product
│       ├── cart_item.dart           # Entidade CartItem (product + quantity)
│       └── cart.dart                # Entidade Cart (items + isFinished + getters)
│
└── presentation/                    # Camada de apresentação
    ├── store/
    │   └── cart_store.dart          # Estado global do carrinho (singleton ChangeNotifier)
    ├── catalog/
    │   ├── catalog_view.dart        # Tela: Catálogo de produtos
    │   ├── catalog_viewmodel.dart   # ViewModel do catálogo
    │   └── widgets/
    │       ├── cart_icon_badge.dart # Ícone do carrinho com badge
    │       └── product_card.dart    # Card de produto com ações
    ├── cart/
    │   ├── cart_view.dart           # Tela: Carrinho
    │   ├── cart_viewmodel.dart      # ViewModel do carrinho
    │   └── widgets/
    │       ├── cart_item_tile.dart  # Item do carrinho com controles
    │       └── order_summary.dart   # Resumo do pedido (itens, subtotal, total)
    └── order/
        ├── order_view.dart          # Tela: Pedido Finalizado
        ├── order_viewmodel.dart     # ViewModel do pedido
        └── widgets/
            ├── order_item_tile.dart # Item do pedido (somente leitura)
            ├── order_summary.dart   # Resumo com frete e total
            └── success_banner.dart  # Banner de confirmação de pedido

test/
├── helpers/
│   ├── fakes.dart                   # APIs fake determinísticas para testes
│   └── fixtures.dart                # Fixtures de produtos e carrinhos
├── domain/                          # Testes unitários das entidades
├── data/                            # Testes unitários dos DTOs
├── presentation/                    # Testes unitários dos ViewModels
└── integration/                     # Testes de integração do fluxo completo
```

---

## Arquitetura

O projeto segue a arquitetura **MVVM** recomendada pelo time do Flutter, com separação clara em quatro camadas:

```
┌─────────────────────────────────────────────────────────┐
│                        View                             │
│  (StatefulWidget + ListenableBuilder)                   │
│  Renderiza UI e repassa interações ao ViewModel         │
└──────────────────────┬──────────────────────────────────┘
                       │ observa / chama
┌──────────────────────▼──────────────────────────────────┐
│                     ViewModel                           │
│  (ChangeNotifier + Commands)                            │
│  Orquestra chamadas de serviço, aplica regras de        │
│  negócio e atualiza a CartStore                         │
└───────────┬────────────────────────┬────────────────────┘
            │ lê/escreve             │ chama
┌───────────▼──────────┐  ┌─────────▼──────────────────┐
│      CartStore        │  │       Data (Services)       │
│  (Singleton global   │  │  ProductsApi / CartApi /    │
│   ChangeNotifier)    │  │  CheckoutApi                │
└───────────────────────┘  └─────────────────────────────┘
                                     │ retorna
                           ┌─────────▼──────────────────┐
                           │     Domain (Models)         │
                           │  Product / Cart / CartItem  │
                           └────────────────────────────┘
```

### Padrões utilizados

#### `Result<T>` — Tipo sealed para respostas

Toda operação de serviço retorna `Result<T>`, eliminando o uso de exceções para controle de fluxo:

```dart
sealed class Result<T> {}
class Success<T> extends Result<T> { final T data; }
class Failure<T> extends Result<T> { final String message; }
```

#### `Command` / `Command1` — Encapsulamento de operações assíncronas

Cada ação do ViewModel é um `Command`, que gerencia `running`, `result` e previne execução dupla:

```dart
// Sem argumento
final loadProducts = Command(_loadProducts);

// Com um argumento
final addToCart = Command1<Cart, Product>(_addToCart);

// Na View
await viewModel.addToCart.execute(product);
if (viewModel.addToCart.result case Failure(:final message)) {
  showErrorSnackbar(context, message);
}
```

#### `CartStore` — Fonte única de verdade

O carrinho é um singleton `ChangeNotifier` acessado por todas as telas. Não possui dependências de serviços externos; é atualizado exclusivamente pelos ViewModels após resultados bem-sucedidos da API.

#### `ListenableBuilder` — Reatividade sem pacotes externos

As Views utilizam `ListenableBuilder` nativo do Flutter para reagir ao ViewModel e à `CartStore`:

```dart
ListenableBuilder(
  listenable: Listenable.merge([viewModel, CartStore.instance]),
  builder: (context, _) { ... },
)
```

---

## Decisões Técnicas

| Decisão | Justificativa |
|---|---|
| Sem packages de state management | Uso do `ChangeNotifier` nativo, conforme recomendação oficial do Flutter para MVVM |
| `sealed class Result<T>` | Tipagem explícita de sucesso/erro; permite pattern matching exaustivo com `switch` |
| `CartStore` singleton | Fonte única de verdade para o carrinho; acessível por qualquer ViewModel sem injeção de dependência adicional |
| DTOs separados das entidades | A camada `data/` é responsável pela serialização; `domain/` contém apenas lógica de negócio pura |
| Injeção de APIs nos ViewModels | Permite testes unitários determinísticos sem mocks externos (apenas `flutter_test`) |
| 20% de falha aleatória nas APIs | Simula instabilidade real de rede; garante que o app lida corretamente com erros em todos os fluxos |
