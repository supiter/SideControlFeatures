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
  
  @AppStorage("cwButton", store: DefaultValues.flexStore) var cwButton = false
  @AppStorage("eqButton", store: DefaultValues.flexStore) var eqButton = false
  @AppStorage("ph1Button", store: DefaultValues.flexStore) var ph1Button = false
  @AppStorage("ph2Button", store: DefaultValues.flexStore) var ph2Button = false
  @AppStorage("rxButton", store: DefaultValues.flexStore) var rxButton = false
  @AppStorage("txButton", store: DefaultValues.flexStore) var txButton = false
  @AppStorage("txEqSelected", store: DefaultValues.flexStore) var txEqSelected = false

  @Dependency(\.objectModel) var objectModel
  
  public struct State: Equatable {
//    var cwButton: Bool { didSet { UserDefaults.standard.set(cwButton, forKey: "cwButton") } }
//    var eqButton: Bool { didSet { UserDefaults.standard.set(eqButton, forKey: "eqButton") } }
    var height: CGFloat
//    var ph1Button: Bool { didSet { UserDefaults.standard.set(ph1Button, forKey: "ph1Button") } }
//    var ph2Button: Bool { didSet { UserDefaults.standard.set(ph2Button, forKey: "ph2Button") } }
//    var rxButton: Bool { didSet { UserDefaults.standard.set(rxButton, forKey: "rxButton") } }
//    var txButton: Bool { didSet { UserDefaults.standard.set(txButton, forKey: "txButton") } }
//    var txEqSelected: Bool { didSet { UserDefaults.standard.set(txEqSelected, forKey: "txEqSelected") } }

    var cwState: CwFeature.State?
    var eqState: EqFeature.State?
    var ph1State: Ph1Feature.State?
    var ph2State: Ph2Feature.State?
    var rxState: FlagFeature.State?
    var txState: TxFeature.State?
    
    public init(
//      cwButton: Bool = UserDefaults.standard.bool(forKey: "cwButton"),
//      eqButton: Bool = UserDefaults.standard.bool(forKey: "eqButton"),
      height: CGFloat = 400
//      ph1Button: Bool = UserDefaults.standard.bool(forKey: "ph1Button"),
//      ph2Button: Bool = UserDefaults.standard.bool(forKey: "ph2Button"),
//      rxButton: Bool = UserDefaults.standard.bool(forKey: "rxButton"),
//      txButton: Bool = UserDefaults.standard.bool(forKey: "txButton"),
//      txEqSelected: Bool = UserDefaults.standard.bool(forKey: "txEqSelected")
    )
    {
//      self.cwButton = cwButton
//      self.eqButton = eqButton
      self.height = height
//      self.ph1Button = ph1Button
//      self.ph2Button = ph2Button
//      self.rxButton = rxButton
//      self.txButton = txButton
//      self.txEqSelected = txEqSelected
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
          if cwButton { state.cwState = CwFeature.State() }
          if eqButton { state.eqState = EqFeature.State(id: txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue) }
          if ph1Button { state.ph1State = Ph1Feature.State() }
          if ph2Button { state.ph2State = Ph2Feature.State() }
          //        if state.rxButton { state.rxState = RxFeature.State() }
          if txButton { state.txState = TxFeature.State() }
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
        cwButton.toggle()
        if cwButton {
          state.cwState = CwFeature.State()
        } else {
          state.cwState = nil
        }
        return .none
        
      case .eqButton:
        eqButton.toggle()
        if eqButton {
          state.eqState = EqFeature.State(id: txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue)
        } else {
          state.eqState = nil
        }
        return .none
        
      case .ph1Button:
        ph1Button.toggle()
        if ph1Button {
          state.ph1State = Ph1Feature.State()
        } else {
          state.ph1State = nil
        }
        return .none
        
      case .ph2Button:
        ph2Button.toggle()
        if ph2Button {
          state.ph2State = Ph2Feature.State()
        } else {
          state.ph2State = nil
        }
        return .none
        
      case .rxButton:
        rxButton.toggle()
        if rxButton {
          state.rxState = FlagFeature.State(isSliceFlag: false)
        } else {
          state.rxState = nil
        }
        return .none
        
      case .txButton:
        txButton.toggle()
        if txButton {
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
        txEqSelected = false
        state.eqState = EqFeature.State(id: txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue)
        return .none
        
      case .eq(.txButton):
        txEqSelected = true
        state.eqState = EqFeature.State(id: txEqSelected ? Equalizer.Kind.tx.rawValue : Equalizer.Kind.rx.rawValue)
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
