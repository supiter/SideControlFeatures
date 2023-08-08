//
//  Ph1Core.swift
//  ViewFeatures/Ph1Feature
//
//  Created by Douglas Adams on 11/15/22.
//

import Foundation
import ComposableArchitecture

import FlexApi

public struct Ph1Feature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    public init() {
    }
  }
  
  public enum Action: Equatable {
    case profileProperty(Profile, String, String)
    case transmitProperty(Transmit, Transmit.Property, String)
  }

  public func reduce(into state: inout State, action: Action) ->  Effect<Action> {
    switch action {

    case let .transmitProperty(transmit, property, value):
      return .run { _ in await transmit.setProperty(property, value) }

    case let .profileProperty(profile, cmd, name):
      return .run { _ in await profile.setProperty(cmd, name) }
    }
  }
}
