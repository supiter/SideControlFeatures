//
//  TxRxAntennaCore.swift
//  
//
//  Created by Douglas Adams on 6/12/23.
//

import ComposableArchitecture
import Foundation

import FlexApi

public struct TxRxAntenna: ReducerProtocol {
  
  public init() {}
  
  public struct State: Equatable {
    
    public init() {}
    
  }

  public enum Action: Equatable {
    case panadapterProperty(Panadapter, Panadapter.Property, String)
    case rxChoice(Slice, String)
    case txChoice(Slice, String)
  }

  public func reduce(into state: inout State, action: Action) ->  EffectTask<Action> {
    switch action {
      
    case let .panadapterProperty(panadapter, property, value):
      return .run { _ in
        await panadapter.setProperty(property, value)
      }

    case let .rxChoice(slice, value):
      return .run { _ in
        await slice.setProperty(.rxAnt, value)
      }

    case let .txChoice(slice, value):
      return .run { _ in
        await slice.setProperty(.txAnt, value)
      }

    }
  }
}
