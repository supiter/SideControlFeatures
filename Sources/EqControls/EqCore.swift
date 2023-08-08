//
//  EqCore.swift
//  ViewFeatures/EqFeature
//
//  Created by Douglas Adams on 11/13/22.
//

import Foundation
import ComposableArchitecture

import FlexApi

public struct EqFeature: Reducer {
  public init() {}

  public struct State: Equatable {
    var id: String
    
    public init(id: String) {
      self.id = id
    }
  }
  
  public enum Action: Equatable {
    case flatButton(Equalizer)
    case rxButton(Bool)
    case txButton(Bool)
    case equalizerProperty(Equalizer, Equalizer.Property, String)
  }
  
  public func reduce(into state: inout State, action: Action) ->  Effect<Action> {
    switch action {

    case let .flatButton(eq):
      return .run { _ in await eq.flat() }
      
    case .rxButton(_), .txButton(_):
      // action taken in parent feature
      return .none

    case let .equalizerProperty(eq, level, stringValue):
      return .run { _ in await eq.setProperty(level, stringValue) }
    }
  }
}
