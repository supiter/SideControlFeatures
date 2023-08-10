//
//  Ph2Core.swift
//  ViewFeatures/Ph2Feature
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import FlexApi

public struct Ph2Feature: Reducer {
  public init(){}

  public struct State: Equatable {
    public init() {
    }
  }

  public enum Action: Equatable {
    case transmitProperty(Transmit, Transmit.Property, String)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let .transmitProperty(transmit, property, value):
        return .run { _ in await transmit.setProperty(property, value) }
      }
    }
  }
}
