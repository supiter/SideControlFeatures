// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SideControlFeatures",
  platforms: [
    .macOS(.v13),
  ],
  
  products: [
    .library(name: "SidePanel", targets: ["SidePanel"]),
    .library(name: "CwControls", targets: ["CwControls"]),
    .library(name: "EqControls", targets: ["EqControls"]),
    .library(name: "Ph1Controls", targets: ["Ph1Controls"]),
    .library(name: "Ph2Controls", targets: ["Ph2Controls"]),
    .library(name: "TxControls", targets: ["TxControls"]),
  ],
  
  dependencies: [
    // ----- K3TZR -----
    .package(url: "https://github.com/K3TZR/ApiFeatures.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/CustomControlFeatures.git", branch: "main"),
    .package(url: "https://github.com/K3TZR/FlagFeatures.git", branch: "main"),
    // ----- OTHER -----
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
  ],
  
  targets: [
    // --------------- Modules ---------------
    // SideControlFeature
    .target( name: "SidePanel", dependencies: [
      "CwControls",
      "EqControls",
      "Ph1Controls",
      "Ph2Controls",
      "TxControls",
      .product(name: "Flag", package: "FlagFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // CwControls
    .target( name: "CwControls", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "LevelIndicatorView", package: "CustomControlFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // EqControls
      .target( name: "EqControls", dependencies: [
        .product(name: "FlexApi", package: "ApiFeatures"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]),
    
    // Ph1Controls
    .target( name: "Ph1Controls", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "Shared", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // Ph2Controls
    .target( name: "Ph2Controls", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // TxControls
    .target( name: "TxControls", dependencies: [
      .product(name: "FlexApi", package: "ApiFeatures"),
      .product(name: "Shared", package: "ApiFeatures"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // ---------------- Tests ----------------
  ]
)
