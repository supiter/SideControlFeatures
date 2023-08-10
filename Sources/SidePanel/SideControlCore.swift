//
//  SideControlCore.swift
//  SideControlFeatures/SideControlFeature
//
//  Created by Douglas Adams on 11/13/22.
//

import ComposableArchitecture
import Foundation
import SwiftUI

import FlexApi
import CwControls
import EqControls
import Flag
import Ph1Controls
import Ph2Controls
import Shared
import TxControls

public struct SideControlFeature: Reducer {
  
  public init() {}
  
  @Dependency(\.objectModel) var objectModel
  
  public struct State: Equatable {
    var cwButton: Bool
    var eqButton: Bool
    var ph1Button: Bool
    var ph2Button: Bool
    var rxButton: Bool
    var txButton: Bool
    var txEqSelected: Bool

    var height: CGFloat

    var cwState: CwFeature.State?
    var eqState: EqFeature.State?
    var ph1State: Ph1Feature.State?
    var ph2State: Ph2Feature.State?
    var rxState: FlagFeature.State?
    var txState: TxFeature.State?
    
    public init(
      cwButton: Bool = false,
      eqButton: Bool = false,
      ph1Button: Bool = false,
      ph2Button: Bool = false,
      rxButton: Bool = false,
      txButton: Bool = false,
      txEqSelected: Bool = false,

      height: CGFloat = 400
    )
    {
      self.cwButton = cwButton
      self.eqButton = eqButton
      self.ph1Button = ph1Button
      self.ph2Button = ph2Button
      self.rxButton = rxButton
      self.txButton = txButton
      self.txEqSelected = txEqSelected

      self.height = height
    }
  }
  
  public enum Action: Equatable {
    // subview related
    case cw(CwFeature.Action)
    case eq(EqFeature.Action)
    case openClose(Bool)
    case ph1(Ph1Feature.Action)
    case ph2(Ph2Feature.Action)
    case rx(FlagFeature.Action)
    case tx(TxFeature.Action)
    
    // UI controls
    case cwButton
    case eqButton
    case ph1Button
    case ph2Button
    case rxButton
    case txButton
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .openClose(let open):
        if open {
          if state.cwButton { state.cwState = CwFeature.State() }
          if state.eqButton { state.eqState = EqFeature.State(id: state.txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue) }
          if state.ph1Button { state.ph1State = Ph1Feature.State() }
          if state.ph2Button { state.ph2State = Ph2Feature.State() }
          //        if state.rxButton { state.rxState = RxFeature.State() }
          if state.txButton { state.txState = TxFeature.State() }
        } else {
          state.cwState = nil
          state.eqState = nil
          state.ph1State = nil
          state.ph2State = nil
          //        state.rxState = nil
          state.txState = nil
        }
        return .none

      case .cwButton:
        state.cwButton.toggle()
        if state.cwButton {
          state.cwState = CwFeature.State()
        } else {
          state.cwState = nil
        }
        return .none
        
      case .eqButton:
        state.eqButton.toggle()
        if state.eqButton {
          state.eqState = EqFeature.State(id: state.txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue)
        } else {
          state.eqState = nil
        }
        return .none
        
      case .ph1Button:
        state.ph1Button.toggle()
        if state.ph1Button {
          state.ph1State = Ph1Feature.State()
        } else {
          state.ph1State = nil
        }
        return .none
        
      case .ph2Button:
        state.ph2Button.toggle()
        if state.ph2Button {
          state.ph2State = Ph2Feature.State()
        } else {
          state.ph2State = nil
        }
        return .none
        
      case .rxButton:
        state.rxButton.toggle()
        if state.rxButton {
          state.rxState = FlagFeature.State(isSliceFlag: false)
        } else {
          state.rxState = nil
        }
        return .none
        
      case .txButton:
        state.txButton.toggle()
        if state.txButton {
          state.txState = TxFeature.State()
        } else {
          state.txState = nil
        }
        return .none
        
        // ----------------------------------------------------------------------------
        // MARK: - Actions from other features
        
      case .cw(_):
        return .none
        
      case .eq(.rxButton):
        state.txEqSelected = false
        state.eqState = EqFeature.State(id: state.txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue)
        return .none
        
      case .eq(.txButton):
        state.txEqSelected = true
        state.eqState = EqFeature.State(id: state.txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue)
        return .none
        
      case .eq(_):
        // all others ignored
        return .none

      case .ph1(_):
        return .none
        
      case .ph2(_):
        return .none
        
      case .rx(_):
        return .none
        
      case .tx(_):
        return .none
        
      }
    }
    
    // Reducers for other features
    .ifLet(\.cwState, action: /Action.cw) {
      CwFeature()
    }
    .ifLet(\.eqState, action: /Action.eq) {
      EqFeature()
    }
    .ifLet(\.ph1State, action: /Action.ph1) {
      Ph1Feature()
    }
    .ifLet(\.ph2State, action: /Action.ph2) {
      Ph2Feature()
    }
    .ifLet(\.rxState, action: /Action.rx) {
      FlagFeature()
    }
    .ifLet(\.txState, action: /Action.tx) {
      TxFeature()
    }
  }
}
