// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ControlFeatures",
  platforms: [
    .macOS(.v13),
  ],
  
  products: [
    .library(name: "ControlFeature", targets: ["ControlFeature"]),
    .library(name: "CwFeature", targets: ["CwFeature"]),
    .library(name: "FlagFeature", targets: ["FlagFeature"]),
  ],
  
  dependencies: [
    // ----- K3TZR -----
    .package(url: "https://github.com/K3TZR/ApiFeatures.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/SharedFeatures.git", branch: "main"),
    // ----- OTHER -----
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
  ],
  
  targets: [
    // --------------- Modules ---------------
    // ControlFeature
    .target( name: "ControlFeature", dependencies: [
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
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "LevelIndicatorView", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // EqFeature
      .target( name: "EqFeature", dependencies: [
        .product(name: "FlexApi", package: "ApiFeatures"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]),
    
    // FlagFeature
    .target(name: "FlagFeature", dependencies: [
      .product(name: "ApiIntView", package: "SharedFeatures"),
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "LevelIndicatorView", package: "SharedFeatures"),
      .product(name: "Shared", package: "SharedFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph1Feature
    .target( name: "Ph1Feature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph2Feature
    .target( name: "Ph2Feature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // TxFeature
    .target( name: "TxFeature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ---------------- Tests ----------------
  ]
)
