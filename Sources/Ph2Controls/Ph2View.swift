//
//  Ph2View.swift
//  ViewFeatures/Ph2Feature
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import ApiIntView
import FlexApi

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph2View: View {
  let store: StoreOf<Ph2Feature>
  
  public init(store: StoreOf<Ph2Feature>) {
    self.store = store
  }
  
  @Dependency(\.objectModel) var objectModel
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          ButtonsView(viewStore: viewStore, transmit: objectModel.transmit)
          SlidersView(viewStore: viewStore, transmit: objectModel.transmit)
        }
        TxFilterView(viewStore: viewStore, transmit: objectModel.transmit)
        MicButtonsView(viewStore: viewStore, transmit: objectModel.transmit)
        Divider().background(.blue)
      }
    }
  }
}

private struct ButtonsView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: 10) {
      Group {
        Text("AM Carrier")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.voxEnabled},
          send: { .transmitProperty(transmit, .voxEnabled, $0.as1or0) } )) { Text("VOX").frame(width: 55) }
        Text("Vox Delay")
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.companderEnabled},
          send: { .transmitProperty(transmit, .companderEnabled, $0.as1or0) } )) { Text("DEXP").frame(width: 55) }
      }.toggleStyle(.button)
    }
  }
}

private struct SlidersView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(spacing: 8) {
      HStack(spacing: 20) {
        Text("\(transmit.carrierLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.carrierLevel) }, send: { .transmitProperty(transmit, .amCarrierLevel, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.voxLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxLevel) }, send: { .transmitProperty(transmit, .voxLevel, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.voxDelay)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.voxDelay) }, send: { .transmitProperty(transmit, .voxDelay, String(Int($0))) }), in: 0...100)
      }
      HStack(spacing: 20) {
        Text("\(transmit.companderLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.companderLevel) }, send: { .transmitProperty(transmit, .companderLevel, String(Int($0))) }), in: 0...100)
      }
    }
//    .frame(width: 180)
  }
}

struct TxFilterView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    
    VStack(alignment: .trailing, spacing: 0) {
      Grid {
        GridRow {
          Text("Tx Filter").frame(width: 90, alignment: .leading)
          HStack(spacing: 2) {
            ApiIntView(value: transmit.txFilterLow, action: {viewStore.send(.transmitProperty(transmit, .txFilterLow, $0)) }, width: 60 )
            
            Stepper("", value: viewStore.binding(
              get: {_ in  transmit.txFilterLow },
              send: { .transmitProperty(transmit, .txFilterLow, String($0)) }),
                    in:  0...transmit.txFilterHigh,
                    step: 50)
            .labelsHidden()
          }
          
          HStack(spacing: 2) {
            ApiIntView(value: transmit.txFilterHigh, action: {viewStore.send(.transmitProperty(transmit, .txFilterHigh, $0)) }, width: 60 )
            
            Stepper("", value: viewStore.binding(
              get: {_ in  transmit.txFilterHigh },
              send: { .transmitProperty(transmit, .txFilterHigh, String($0)) }),
                    in: 0...10_000,
                    step: 50)
            .labelsHidden()
          }
        }
        GridRow {
          Group {
            Text("")
            Text("Low Cut")
            Text("High Cut")
          }
          .font(.footnote)
        }
      }
    }
  }
}

struct MicButtonsView: View {
  let viewStore: ViewStore<Ph2Feature.State, Ph2Feature.Action>
  @ObservedObject var transmit: Transmit
  
  public var body: some View {
    HStack(spacing: 15) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.micBiasEnabled},
          send: { .transmitProperty(transmit, .micBiasEnabled, $0.as1or0) } )) { Text("Bias").frame(width: 55) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.micBoostEnabled},
          send: { .transmitProperty(transmit, .micBoostEnabled, $0.as1or0) } )) { Text("Boost").frame(width: 55) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.meterInRxEnabled},
          send: { .transmitProperty(transmit, .meterInRxEnabled, $0.as1or0) } )) { Text("Meter in Rx").frame(width: 70) }
      }
      .toggleStyle(.button)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct Ph2View_Previews: PreviewProvider {
  static var previews: some View {
    Ph2View(store: Store(initialState: Ph2Feature.State()) { Ph2Feature() })
      .frame(width: 275)
  }
}
