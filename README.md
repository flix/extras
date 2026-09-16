# Flix Extras

A collection of functionality that extend the official Flix library.

## Modules

- `Extras.DelayList` — a lazy list whose elements are computed on demand.
- `Extras.DelayMap` — a map whose values are computed on demand.
- `Extras.Graph` — functions on directed graphs represented as collections of edges.
- `Extras.Queue` — an immutable first-in, first-out queue.

## Usage

Add the package to the `flix.toml` of your own project:

```toml
[dependencies]
"github:flix/extras" = "0.2.0"
```

Flix Extras uses effects that require an unrestricted security context. If your
project is built with restricted security, declare the dependency in its long
form instead:

```toml
[dependencies]
"github:flix/extras" = { version = "0.2.0", security = "unrestricted" }
```
