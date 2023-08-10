//
//  TxCore.swift
//  ViewFeatures/TxFeature
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import FlexApi

public struct TxFeature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case atuProperty(Atu, Atu.Property, String)
    case transmitProperty(Transmit, Transmit.Property, String)
    case profileProperty(Profile, String, String)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .atuProperty(atu, property, value):
        return .run { _ in await atu.setProperty(property, value) }
        
      case let .transmitProperty(transmit, property, value):
        return .run { _ in await transmit.setProperty(property, value) }
        
      case let .profileProperty(profile, cmd, name):
        return .run { _ in await profile.setProperty(cmd, name) }
      }
    }
  }
}
