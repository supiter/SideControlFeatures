//
//  EqView.swift
//  ViewFeatures/EqFeature
//
//  Created by Douglas Adams on 4/27/22.
//

import SwiftUI
import ComposableArchitecture

import FlexApi
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct EqView: View {
  let store: StoreOf<EqFeature>
  
  @Dependency(\.objectModel) var objectModel

  public init(store: StoreOf<EqFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading, spacing: 10) {
        HeadingView(viewStore: viewStore, equalizer: objectModel.equalizers[id: viewStore.id] ?? Equalizer("dummy"))
        HStack(spacing: 20) {
          ButtonView(viewStore: viewStore, equalizer: objectModel.equalizers[id: viewStore.id] ?? Equalizer("dummy"))
          SliderView(viewStore: viewStore, equalizer: objectModel.equalizers[id: viewStore.id] ?? Equalizer("dummy"))
        }
        Divider().background(.blue)
      }
    }
  }
}

private struct HeadingView: View {
  let viewStore: ViewStore<EqFeature.State, EqFeature.Action>
  @ObservedObject var equalizer: Equalizer

  var body: some View {

    HStack(spacing: 0) {
      Button( action: { viewStore.send(.flatButton(equalizer)) }) { Text("Flat") }
      Text("").frame(width: 15)
      Group {
        Text("63")
        Text("125")
        Text("250")
        Text("500")
        Text("1k")
        Text("2k")
        Text("4k")
        Text("8k")
      }.frame(width:25)
    }
  }
}

private struct ButtonView: View {
  let viewStore: ViewStore<EqFeature.State, EqFeature.Action>
  @ObservedObject var equalizer: Equalizer
  
  var body: some View {

    VStack(alignment: .center, spacing: 25) {
      Text("+10 Db")
      Group {
        Toggle("On", isOn: viewStore.binding(
          get: {_ in equalizer.eqEnabled } ,
          send: { .equalizerProperty(equalizer, .eqEnabled, $0.as1or0) } ))
        Toggle("Rx", isOn: viewStore.binding(
          get: {_ in viewStore.id == Equalizer.Kind.rx.rawValue },
          send: { .rxButton($0) } ))
        Toggle("Tx", isOn: viewStore.binding(
          get: {_ in viewStore.id == Equalizer.Kind.tx.rawValue },
          send: { .txButton($0) } ))
      }.toggleStyle(.button)
      Text("-10 Db")
    }
  }
}

private struct SliderView: View {
  let viewStore: ViewStore<EqFeature.State, EqFeature.Action>
  @ObservedObject var equalizer: Equalizer
  
  var body: some View {
    
    VStack(alignment: .center, spacing: 5) {
      Group {
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz63)}, send: { .equalizerProperty(equalizer, .hz63, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz125)}, send: { .equalizerProperty(equalizer, .hz125, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz250)}, send: { .equalizerProperty(equalizer, .hz250, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz500)}, send: { .equalizerProperty(equalizer, .hz500, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz1000)}, send: { .equalizerProperty(equalizer, .hz1000, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz2000)}, send: { .equalizerProperty(equalizer, .hz2000, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz4000)}, send: { .equalizerProperty(equalizer, .hz4000, String(Int($0))) }), in: -10...10)
        Slider(value: viewStore.binding(get: {_ in Double(equalizer.hz8000)}, send: { .equalizerProperty(equalizer, .hz8000, String(Int($0))) }), in: -10...10)
      }
      .frame(width: 180)
    }
    .rotationEffect(.degrees(-90), anchor: .center)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct EqView_Previews: PreviewProvider {
  
  static var previews: some View {

    Group {
      EqView(store: Store(initialState: EqFeature.State(id: Equalizer.Kind.rx.rawValue)) {
        EqFeature()
      })
      .frame(width: 275, height: 250)
      .previewDisplayName("Rx Equalizer")
      
      
      EqView(store: Store(initialState: EqFeature.State(id: Equalizer.Kind.tx.rawValue)) {
        EqFeature()
      })
      .frame(width: 275, height: 250)
      .previewDisplayName("Tx Equalizer")
    }
  }
}
