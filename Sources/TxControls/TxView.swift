//
//  TxView.swift
//  ViewFeatures/TxFeature
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import LevelIndicatorView
import FlexApi
import Shared

public struct TxView: View {
  let store: StoreOf<TxFeature>
  
  public init(store: StoreOf<TxFeature>) {
    self.store = store
  }
  
  @Dependency(\.apiModel) var apiModel
  @Dependency(\.objectModel) var objectModel
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        VStack(alignment: .leading, spacing: 10)  {
          LevelsView()
          PowerView(viewStore: viewStore, transmit: objectModel.transmit)
          ProfileView(viewStore: viewStore, txProfile: objectModel.profiles[id: "tx"] ?? Profile("empty"), atu: objectModel.atu)
          AtuStatusView(viewStore: viewStore, atu: objectModel.atu)
        }
        VStack(alignment: .center, spacing: 10) {
          ButtonsView(viewStore: viewStore, transmit: objectModel.transmit, radio: apiModel.radio ?? Radio(Packet()), atu: objectModel.atu)
          Divider().background(.blue)
        }
      }
    }
  }
}

private struct LevelsView: View {
  
  public var body: some View {
    VStack(alignment: .center, spacing: 5)  {
      LevelIndicatorView(level: 75, type: .power)
      LevelIndicatorView(level: 1.5, type: .swr)
    }
  }
}

private struct PowerView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var transmit: Transmit

  public var body: some View {
    VStack(spacing: 5) {
      HStack(spacing: 10) {
        Text("Rf Power").frame(width: 75, alignment: .leading)
        HStack(spacing: 20) {
          Text("\(transmit.rfPower)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.rfPower) }, send: { .transmitProperty(transmit, .rfPower, String(Int($0))) }), in: 0...100)
        }
      }
      HStack(spacing: 10) {
        Text("Tune Power").frame(width: 75, alignment: .leading)
        HStack(spacing: 20) {
          Text("\(transmit.tunePower)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.tunePower) }, send: { .transmitProperty(transmit, .tunePower, String(Int($0))) }), in: 0...100)
        }
      }
    }
  }
}

private struct ProfileView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var txProfile: Profile
  @ObservedObject var atu: Atu

  public var body: some View {
    HStack(spacing: 25) {
      Picker("", selection: viewStore.binding(
        get: {_ in  txProfile.current },
        send: { .profileProperty(txProfile, "load", $0) })) {
          ForEach(txProfile.list, id: \.self) {
          Text($0).tag($0)
        }
      }
      .labelsHidden()
      .pickerStyle(.menu)
      .frame(width: 200, alignment: .leading)
      
      Button("Save", action: {})
        .font(.footnote)
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.blue)
    }
  }
}

private struct AtuStatusView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var atu: Atu
  
  public var body: some View {
    HStack(spacing: 20) {
      Toggle(isOn: viewStore.binding(
        get: {_ in atu.enabled},
        send: { .atuProperty(atu, .enabled, $0.as1or0) })) { Text("ATU").frame(width: 40) }
        .toggleStyle(.button)
      
      Text(atu.status.rawValue).frame(width: 180)
        .border(.secondary)
    }
  }
}

private struct ButtonsView: View {
  let viewStore: ViewStore<TxFeature.State, TxFeature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  @ObservedObject var atu: Atu

  public var body: some View {
    HStack(spacing: 45) {
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in atu.memoriesEnabled},
          send: { .atuProperty(atu, .memoriesEnabled, $0.as1or0) })) { Text("MEM").frame(width: 40) }
        Toggle(isOn: viewStore.binding(
          get: {_ in transmit.tune},
          send: { .transmitProperty(transmit, .tune, $0.as1or0) } )) { Text("TUNE").frame(width: 40) }
        Toggle(isOn: viewStore.binding(
          get: {_ in radio.mox},
          send: { .transmitProperty(transmit, .mox, $0.as1or0) } )) { Text("MOX").frame(width: 40) }
      }
      .toggleStyle(.button)
    }
  }
}

struct TxView_Previews: PreviewProvider {
    static var previews: some View {
      TxView(store: Store(initialState: TxFeature.State(), reducer: TxFeature()))
        .frame(width: 275)
    }
}
