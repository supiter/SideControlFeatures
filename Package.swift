// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SideControlFeatures",
  platforms: [
    .macOS(.v13),
  ],
  
  products: [
    .library(name: "SideControlFeature", targets: ["SideControlFeature"]),
    .library(name: "SideCwFeature", targets: ["SideCwFeature"]),
    .library(name: "SideEqFeature", targets: ["SideEqFeature"]),
    .library(name: "FlagFeature", targets: ["FlagFeature"]),
    .library(name: "SidePh1Feature", targets: ["SidePh1Feature"]),
    .library(name: "SidePh2Feature", targets: ["SidePh2Feature"]),
    .library(name: "SideTxFeature", targets: ["SideTxFeature"]),
  ],
  
  dependencies: [
    // ----- K3TZR -----
    .package(url: "https://github.com/K3TZR/ApiFeatures.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/CustomControlFeatures.git", branch: "main"),
    // ----- OTHER -----
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
  ],
  
  targets: [
    // --------------- Modules ---------------
    // SideControlFeature
    .target( name: "SideControlFeature", dependencies: [
      "SideCwFeature",
      "SideEqFeature",
      "FlagFeature",
      "SidePh2Feature",
      "SidePh1Feature",
      "SideTxFeature",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // CwFeature
    .target( name: "SideCwFeature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "LevelIndicatorView", package: "CustomControlFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // EqFeature
      .target( name: "SideEqFeature", dependencies: [
        .product(name: "FlexApi", package: "ApiFeatures"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]),
    
    // FlagFeature
    .target(name: "FlagFeature", dependencies: [
      .product(name: "ApiIntView", package: "CustomControlFeatures"),
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "LevelIndicatorView", package: "CustomControlFeatures"),
//      .product(name: "Shared", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph1Feature
    .target( name: "SidePh1Feature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
//      .product(name: "Shared", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph2Feature
    .target( name: "SidePh2Feature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // TxFeature
    .target( name: "SideTxFeature", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
//      .product(name: "Shared", package: "ApiFeature"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ---------------- Tests ----------------
  ]
)
