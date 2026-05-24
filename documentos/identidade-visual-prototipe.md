# Identidade visual — Prototipe

Este documento registra a paleta de cores fornecida para guiar a interface do app Chave 26.

## Cores principais

| Função | HEX |
| --- | --- |
| Azul ciano do fundo | `#0397DD` |
| Azul médio | `#0E7CC7` |
| Azul royal | `#1D58AA` |
| Azul índigo escuro | `#274299` |
| Azul marinho / contorno | `#060D5B` |
| Creme dos títulos | `#FDFBDB` |
| Branco dos detalhes/logo | `#F7FBFF` |

## Cores de apoio do mascote

| Função | HEX |
| --- | --- |
| Roxo principal | `#444EDB` |
| Roxo sombra | `#383EAA` |
| Azul claro / barriga | `#3D9EDD` |
| Preto dos óculos | `#161617` |

## Gradiente recomendado para o fundo

```css
background: linear-gradient(
  90deg,
  #0397DD 0%,
  #0E7CC7 35%,
  #1D58AA 70%,
  #274299 100%
);
```

## Variáveis CSS de referência

Mesmo o app sendo Flutter/Dart, estas variáveis servem como referência visual e podem ser traduzidas depois para constantes Dart.

```css
:root {
  --prototipe-cyan: #0397DD;
  --prototipe-blue: #0E7CC7;
  --prototipe-royal: #1D58AA;
  --prototipe-indigo: #274299;
  --prototipe-navy: #060D5B;

  --prototipe-cream: #FDFBDB;
  --prototipe-white: #F7FBFF;
  --prototipe-black: #161617;

  --prototipe-purple: #444EDB;
  --prototipe-purple-dark: #383EAA;
  --prototipe-aqua: #3D9EDD;
}
```

## Tradução sugerida para Flutter/Dart

Quando a identidade visual for implementada no código, criar constantes Dart com nomes em português, por exemplo:

```dart
class CoresPrototipe {
  static const azulCiano = Color(0xFF0397DD);
  static const azulMedio = Color(0xFF0E7CC7);
  static const azulRoyal = Color(0xFF1D58AA);
  static const azulIndigo = Color(0xFF274299);
  static const azulMarinho = Color(0xFF060D5B);

  static const creme = Color(0xFFFDFBDB);
  static const branco = Color(0xFFF7FBFF);
  static const preto = Color(0xFF161617);

  static const roxo = Color(0xFF444EDB);
  static const roxoEscuro = Color(0xFF383EAA);
  static const azulClaro = Color(0xFF3D9EDD);
}
```

Observação: em Flutter, o `0xFF` inicial indica opacidade total antes do código HEX da cor.
