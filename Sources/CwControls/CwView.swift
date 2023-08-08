//
//  CwView.swift
//  ViewFeatures/CwFeature
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import ApiIntView
import LevelIndicatorView
import FlexApi

// ----------------------------------------------------------------------------
// MARK: - View

public struct CwView: View {
  let store: StoreOf<CwFeature>
  
  @Dependency(\.objectModel) var objectModel
  
  public init(store: StoreOf<CwFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 10)  {
        LevelIndicatorView(level: 0.25, type: .alc)
          .padding(.bottom, 10)
        
        HStack {
          ButtonsView(viewStore: viewStore, transmit: objectModel.transmit)
          SlidersView(viewStore: viewStore, transmit: objectModel.transmit)
        }
        BottomButtonsView(viewStore: viewStore, transmit: objectModel.transmit)
        Divider().background(.blue)
      }
    }
  }
}

private struct ButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 13){
      Group {
        Text("Delay")
        Text("Speed")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwSidetoneEnabled },
          send: { .transmitProperty(transmit, .cwSidetoneEnabled, $0.as1or0) } )) {Text("Sidetone").frame(width: 55)}
          .toggleStyle(.button)
        Text("Pan")
      }
    }
  }
}

private struct SlidersView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(spacing: 8) {
      HStack(spacing: 10) {
        Text("\(transmit.cwBreakInDelay)").frame(width: 35, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwBreakInDelay) }, send: { .transmitProperty(transmit, .cwBreakInDelay, String(Int($0))) }), in: 30...2_000)
      }
      HStack(spacing: 10) {
        Text("\(transmit.cwSpeed)").frame(width: 35, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwSpeed) }, send: { .transmitProperty(transmit, .cwSpeed, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("\(transmit.cwMonitorGain)").frame(width: 35, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorGain) }, send: { .transmitProperty(transmit, .cwMonitorGain, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 10) {
        Text("\(transmit.cwMonitorPan)").frame(width: 35, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.cwMonitorPan) }, send: { .transmitProperty(transmit, .cwMonitorPan, String(Int($0))) }), in: 0...100)
      }
    }
  }
}

struct BottomButtonsView: View {
  let viewStore: ViewStore<CwFeature.State, CwFeature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    HStack(spacing: 10) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwBreakInEnabled },
          send: { .transmitProperty(transmit, .cwBreakInEnabled, $0.as1or0) } ))
        {Text("BrkIn").frame(width: 45)}
        
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.cwIambicEnabled },
          send: { .transmitProperty(transmit, .cwIambicEnabled, $0.as1or0) } ))
        {Text("Iambic").frame(width: 45)}
      }
      .toggleStyle(.button)
      
      Text("Pitch").frame(width: 35)
      
      ApiIntView(value: transmit.cwPitch, action: { viewStore.send(.transmitProperty(transmit, .cwPitch, $0))}, width: 50)

      Stepper("", value: viewStore.binding(
        get: {_ in  transmit.cwPitch },
        send: { .transmitProperty(transmit, .cwPitch, String($0)) } ),
              in: 100...6000,
              step: 50)
      .labelsHidden()
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct CwView_Previews: PreviewProvider {
  static var previews: some View {
    CwView(store: Store(initialState: CwFeature.State()) { CwFeature() })
      .frame(width: 275, height: 210)
  }
}
