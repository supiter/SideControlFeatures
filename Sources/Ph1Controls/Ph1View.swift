//
//  Ph1View.swift
//  ViewFeatures/Ph1Feature
//
//  Created by Douglas Adams on 11/15/22.
//

import ComposableArchitecture
import SwiftUI

import LevelIndicatorView
import FlexApi
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct Ph1View: View {
  let store: StoreOf<Ph1Feature>
  @ObservedObject var objectModel: ObjectModel
  @ObservedObject var apiModel: ApiModel

  public init(store: StoreOf<Ph1Feature>, objectModel: ObjectModel, apiModel: ApiModel) {
    self.store = store
    self.objectModel = objectModel
    self.apiModel = apiModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        VStack(alignment: .leading, spacing: 10) {
          LevelsView()
          ProfileView(viewStore: viewStore, micProfile: objectModel.profiles[id: "mic"] ?? Profile("empty"))
          MicSelectionView(viewStore: viewStore, transmit: objectModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
          ProcView(viewStore: viewStore, transmit: objectModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
          MonView(viewStore: viewStore, transmit: objectModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
        }
        VStack(alignment: .center, spacing: 10) {
          AccView(viewStore: viewStore, transmit: objectModel.transmit, radio: apiModel.radio ?? Radio(Packet()))
          Divider().background(.blue)
        }
      }
    }
  }
}

private struct LevelsView: View {
  
  public var body: some View {
    VStack(alignment: .center, spacing: 5)  {
      LevelIndicatorView(level: -20.0, type: .micLevel)
      LevelIndicatorView(level: -15.0, type: .compression)
    }
  }
}

private struct ProfileView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var micProfile: Profile
  
  public var body: some View {
    HStack(spacing: 25) {
      Picker("", selection: viewStore.binding(
        get: {_ in  micProfile.current},
        send: { .profileProperty(micProfile, "load", $0) })) {
          ForEach(micProfile.list, id: \.self) {
          Text($0).tag($0)
        }
      }
      .labelsHidden()
      .pickerStyle(.menu)
      .frame(width: 210, alignment: .leading)
      
      Button("Save", action: {})
        .font(.footnote)
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.blue)
    }
  }
}

private struct MicSelectionView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio

  public var body: some View {
    
    HStack(spacing: 10) {
      Picker("", selection: viewStore.binding(
        get: {_ in  transmit.micSelection },
        send: { .transmitProperty(transmit, .micSelection, $0) })) {
          ForEach(radio.micList, id: \.self) {
            Text($0)
          }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .frame(width: 70, alignment: .leading)
      
      HStack(spacing: 20) {
        Text("\(transmit.micLevel)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.micLevel) }, send: { .transmitProperty(transmit, .micLevel, String(Int($0))) }), in: 0...100)
      }
    }
  }
}

private struct ProcView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    VStack(spacing: 0) {
      
      HStack(spacing: 40) {
        Text("NOR")
        Text("DX")
        Text("DX+")
      }
      .padding(.leading, 125)
      .font(.footnote)
      
      HStack(spacing: 10) {
        Toggle(isOn: viewStore.binding(
          get: {_ in  transmit.speechProcessorEnabled },
          send: { .transmitProperty(transmit, .speechProcessorEnabled, $0.as1or0) })) { Text("PROC").frame(width: 55)}
          .toggleStyle(.button)
        
        HStack(spacing: 20) {
          Text("\(transmit.speechProcessorLevel)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(transmit.speechProcessorLevel) }, send: { .transmitProperty(transmit, .speechProcessorLevel, String(Int($0))) }), in: 0...100)
        }
      }
    }
  }
}

private struct MonView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    
    HStack(spacing: 10) {
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.txMonitorEnabled },
        send: { .transmitProperty(transmit, .txMonitorEnabled, $0.as1or0) })) { Text("MON").frame(width: 55)}
        .toggleStyle(.button)
      
      HStack(spacing: 20) {
        Text("\(transmit.ssbMonitorGain)").frame(width: 25, alignment: .trailing)
        Slider(value: viewStore.binding(get: {_ in Double(transmit.ssbMonitorGain) }, send: { .transmitProperty(transmit, .ssbMonitorGain, String(Int($0))) }), in: 0...100)
      }
    }
  }
}

private struct AccView: View {
  let viewStore: ViewStore<Ph1Feature.State, Ph1Feature.Action>
  @ObservedObject var transmit: Transmit
  @ObservedObject var radio: Radio
  
  public var body: some View {
    
    HStack(alignment: .center, spacing: 40) {
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.micAccEnabled },
        send: { .transmitProperty(transmit, .micAccEnabled, $0.as1or0) })) { Text("ACC").frame(width: 40)}
        .toggleStyle(.button)
      
      Toggle(isOn: viewStore.binding(
        get: {_ in  transmit.daxEnabled },
        send: { .transmitProperty(transmit, .daxEnabled, $0.as1or0) })) { Text("DAX").frame(width: 40)}
        .toggleStyle(.button)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct Ph1View_Previews: PreviewProvider {
    static var previews: some View {
      Ph1View(store: Store(initialState: Ph1Feature.State()) { Ph1Feature() }, objectModel: ObjectModel(), apiModel: ApiModel())
        .frame(width: 275, height: 250)
        .previewDisplayName("Ph1")
    }
}
