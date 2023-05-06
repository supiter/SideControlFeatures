// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SideControlFeature",
  platforms: [
    .macOS(.v13),
  ],
  
  products: [
    .library(name: "SideControlFeature", targets: ["SideControlFeature"]),
    .library(name: "CwFeature", targets: ["CwFeature"]),
    .library(name: "FlagFeature", targets: ["FlagFeature"]),
  ],
  
  dependencies: [
    // ----- K3TZR -----
    .package(url: "https://github.com/K3TZR/ApiFeature.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/CustomControlFeature.git", branch: "main"),
    // ----- OTHER -----
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
  ],
  
  targets: [
    // --------------- Modules ---------------
    // SideControlFeature
    .target( name: "SideControlFeature", dependencies: [
      "CwFeature",
      "EqFeature",
      "FlagFeature",
      "Ph2Feature",
      "Ph1Feature",
      "TxFeature",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // CwFeature
    .target( name: "CwFeature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeature"),
      .product(name: "LevelIndicatorView", package: "CustomControlFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // EqFeature
      .target( name: "EqFeature", dependencies: [
        .product(name: "FlexApi", package: "ApiFeature"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]),
    
    // FlagFeature
    .target(name: "FlagFeature", dependencies: [
      .product(name: "ApiIntView", package: "CustomControlFeature"),
      .product(name: "FlexApi", package: "ApiFeature"),
      .product(name: "LevelIndicatorView", package: "CustomControlFeature"),
      .product(name: "Shared", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph1Feature
    .target( name: "Ph1Feature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeature"),
      .product(name: "Shared", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph2Feature
    .target( name: "Ph2Feature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // TxFeature
    .target( name: "TxFeature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeature"),
      .product(name: "Shared", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ---------------- Tests ----------------
  ]
)
