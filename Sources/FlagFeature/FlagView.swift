//
//  FlagView.swift
//  ViewFeatures/FlagFeature
//
//  Created by Douglas Adams on 4/3/21.
//

import ComposableArchitecture
import SwiftUI

import ApiIntView
import LevelIndicatorView
import FlexApi

public enum FlagMode: String {
  case aud
  case dsp
  case mode
  case xrit
  case dax
  case none
}

// ----------------------------------------------------------------------------
// MARK: - Main view

public struct FlagView: View {
  let store: StoreOf<FlagFeature>
  
  public init(store: StoreOf<FlagFeature>) {
    self.store = store
  }
  @State var mode: FlagMode = .none
  
  @Dependency(\.objectModel) var objectModel
  
  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      
      VStack(spacing: 0) {
        if objectModel.activeSlice == nil {
          EmptyView()
        } else {
          Spacer()
          Line1View(viewStore: viewStore, slice: objectModel.activeSlice!, objectModel: objectModel)
          Spacer()
          Line2View(viewStore: viewStore, slice: objectModel.activeSlice!, objectModel: objectModel)
          Spacer()
          SMeterView(viewStore: viewStore, slice: objectModel.activeSlice!, objectModel: objectModel)
          Spacer()
          ButtonView(viewStore: viewStore, slice: objectModel.activeSlice!, objectModel: objectModel, selection: $mode)
          Spacer()
          if mode == .none { Divider().background(.blue) }
        }
      }
      .frame(height: mode == .none ? 120 : 220)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Major views

private struct Line1View: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  @ObservedObject var objectModel: ObjectModel
  
  func filter(_ high: Int, _ low: Int) -> String {
    var width = Float(high - low)
    if width > 999 {
      width = width / 1_000
      return String(format: "%2.1f", width) + "k"
    }
    return String(format: "%3.0f", width)
  }
  
  var body: some View {
    HStack(spacing: 5) {
      Image(systemName: "multiply")
        .onTapGesture { viewStore.send(.closeButton) }
        .disabled(viewStore.isOnSide)
      
      HStack(spacing: 0) {
        Group {
          Picker("", selection: viewStore.binding(
            get: {_ in slice.rxAnt},
            send: { .sliceProperty(slice, .rxAnt, $0) })) {
              ForEach(slice.rxAntList, id: \.self) {
                Text($0).tag($0)
              }
            }
          Picker("", selection: viewStore.binding(
            get: {_ in slice.txAnt},
            send: { .sliceProperty(slice, .txAnt, $0) })) {
              ForEach(slice.txAntList, id: \.self) {
                Text($0).tag($0)
              }
            }
        }
        .labelsHidden()
        .frame(width: 55)
        .controlSize(.small)
      }
      
      HStack {
        Text(filter(slice.filterHigh, slice.filterLow)).font(.system(size: 10))
        Group {
          Text("SPLIT")
            .foregroundColor(slice.splitId != nil ? .yellow : nil)
            .onTapGesture { viewStore.send(.splitClick) }
          Text("TX")
            .foregroundColor(slice.txEnabled ? .red : nil)
            .onTapGesture { viewStore.send(.sliceProperty(slice, .txEnabled, (!slice.txEnabled).as1or0)) }
          Text("A").onTapGesture { viewStore.send(.letterClick) }
        }.font(.title3)
      }
    }
  }
}

private struct Line2View: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  @ObservedObject var objectModel: ObjectModel
  
  var body: some View {
    HStack {
      Image(systemName: slice.locked ? "lock" : "lock.open")
        .onTapGesture {
          viewStore.send(.sliceProperty(slice, .locked, (!slice.locked).as1or0))
        }
      
      Group {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.nbEnabled},
          send: { .sliceProperty(slice, .nbEnabled, ($0).as1or0) })) { Text("NB") }
          .toggleStyle(.button)
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.nrEnabled},
          send: { .sliceProperty(slice, .nrEnabled, ($0).as1or0) })) { Text("NR") }
          .toggleStyle(.button)
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.anfEnabled},
          send: { .sliceProperty(slice, .anfEnabled, ($0).as1or0) })) { Text("ANF") }
          .toggleStyle(.button)
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.qskEnabled},
          send: .qskButton )) { Text("QSK") }
          .toggleStyle(.button)
      }
      .toggleStyle(.button)
      .controlSize(.mini)
      
      ApiIntView(hint: "frequency",
                  value: slice.frequency,
                  formatter: NumberFormatter.dotted,
                 action: { viewStore.send(.sliceProperty(slice, .frequency, $0.toMhz)) },
                  isValid: { $0.isValidFrequency },
                  width: 90
      ).border(.green)
    }
  }
}

private struct SMeterView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  @ObservedObject var objectModel: ObjectModel
  
  var body: some View {
    HStack {
      LevelIndicatorView(level: 10, type: .sMeter)
      Text("+10")
    }
  }
}


private struct ButtonView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  @ObservedObject var objectModel: ObjectModel
  @Binding var selection: FlagMode
  
  var body: some View {
    
    ControlGroup {
      Button(FlagMode.aud.rawValue.uppercased()) { selection = selection == .aud ? .none : .aud }
      Button(FlagMode.dsp.rawValue.uppercased()) { selection = selection == .dsp ? .none : .dsp }
      Button(FlagMode.mode.rawValue.uppercased()) { selection = selection == .mode ? .none : .mode }
      Button(FlagMode.xrit.rawValue.uppercased()) { selection = selection == .xrit ? .none : .xrit }
      Button(FlagMode.dax.rawValue.uppercased()) { selection = selection == .dax ? .none : .dax }
    }.controlSize(.small)
    
    switch selection {
    case .aud:    AudView(viewStore: viewStore, slice: slice)
    case .dsp:    DspView(viewStore: viewStore, slice: slice)
    case .mode:   ModeView(viewStore: viewStore, slice: slice)
    case .xrit:   XritView(viewStore: viewStore, slice: slice)
    case .dax:    DaxView(viewStore: viewStore, slice: slice)
    case .none:   EmptyView()
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Sub views

private struct AudView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
      Grid (verticalSpacing: 10) {
        GridRow {
          Image(systemName: slice.audioMute ? "speaker.slash": "speaker")
            .frame(width: 40)
            .font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .audioMute, (!slice.audioMute).as1or0))
            }
          Slider(value: viewStore.binding(
            get: {_ in Double(slice.audioGain) },
            send: { .sliceProperty(slice, .audioGain, String(Int($0))) } ), in: 0...100)
          .frame(width: 160)
          Text(String(format: "%d",slice.audioGain))
            .frame(width: 40)
            .font(.title3)
            .multilineTextAlignment(.trailing)
        }
        
        GridRow {
          Text("L")
            .font(.title3)
          Slider(value: viewStore.binding(
            get: {_ in Double(slice.audioPan) },
            send: { .sliceProperty(slice, .audioPan, String(Int($0))) } ), in: 0...100).frame(width: 160)
          Text("R")
            .font(.title3)
        }
      }
      Spacer()
      HStack {
        Picker("", selection: viewStore.binding(
          get: {_ in slice.agcMode },
          send: { .sliceProperty(slice, .agcMode, $0) } )) {
            ForEach(Slice.AgcMode.allCases, id: \.self) {
              Text($0.rawValue).tag($0.rawValue)
            }
          }.frame(width: 100)
        Slider(value: viewStore.binding(
          get: {_ in Double(slice.agcThreshold) },
          send: { .sliceProperty(slice, .agcThreshold, String(Int($0))) } ), in: 0...100).frame(width: 100)
        Text(String(format: "%d", slice.agcThreshold))
          .frame(width: 40)
          .font(.title3)
          .multilineTextAlignment(.trailing)
      }
      Spacer()
      Divider().background(.blue)
    }
    .controlSize(.small)
    .frame(height: 100)
  }
}

private struct DspView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  
  var body: some View {
    Grid (verticalSpacing: 5){
      GridRow {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.wnbEnabled},
          send: { .sliceProperty(slice, .wnbEnabled, $0.as1or0) })) { Text("WNB").frame(width: 40) }
          .toggleStyle(.button)
        Slider(value: viewStore.binding(
          get: {_ in Double(slice.wnbLevel)},
          send: { .sliceProperty(slice, .wnbLevel, String(Int($0))) } ), in: 0...100)
        Text(String(format: "%d",slice.wnbLevel))
          .frame(width: 30)
          .font(.title3)
          .multilineTextAlignment(.trailing)
      }
      GridRow {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.nbEnabled},
          send: { .sliceProperty(slice, .nbEnabled, $0.as1or0) })) { Text("NB").frame(width: 40) }
          .toggleStyle(.button)
        Slider(value: viewStore.binding(
          get: {_ in Double(slice.nbLevel)},
          send: { .sliceProperty(slice, .nbLevel, String(Int($0))) } ), in: 0...100)
        Text(String(format: "%d",slice.nbLevel))
          .frame(width: 30)
          .font(.title3)
          .multilineTextAlignment(.trailing)
      }.controlSize(.mini)
      
      GridRow {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.nrEnabled},
          send: { .sliceProperty(slice, .nrEnabled, $0.as1or0) })) { Text("NR").frame(width: 40) }
          .toggleStyle(.button)
        Slider(value: viewStore.binding(
          get: {_ in Double(slice.nrLevel)},
          send: { .sliceProperty(slice, .nrLevel, String(Int($0))) } ), in: 0...100)
        Text(String(format: "%d",slice.nrLevel))
          .frame(width: 30)
          .font(.title3)
          .multilineTextAlignment(.trailing)
      }.controlSize(.mini)
      
      GridRow {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.anfEnabled},
          send: { .sliceProperty(slice, .anfEnabled, $0.as1or0) })) { Text("ANF").frame(width: 40) }
          .toggleStyle(.button)
        Slider(value: viewStore.binding(
          get: {_ in Double(slice.anfLevel)},
          send: { .sliceProperty(slice, .anfLevel, String(Int($0))) } ), in: 0...100)
        Text(String(format: "%d", slice.anfLevel))
          .frame(width: 30)
          .font(.title3)
          .multilineTextAlignment(.trailing)
      }
      Divider().background(.blue)
    }
    .frame(height: 100)
    .controlSize(.small)
  }
}

private struct ModeView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  
  var body: some View {
    
    let width: CGFloat = 45
    
    Grid(horizontalSpacing: 5) {
      GridRow {
        Picker("", selection: viewStore.binding(
          get: {_ in slice.mode},
          send: { .sliceProperty(slice, .mode, $0) } )) {
            ForEach(Slice.Mode.allCases, id: \.self) {
              Text($0.rawValue).tag($0.rawValue)
            }
          }
          .gridCellColumns(2)
          .frame(width: 80)
        Button(action: { viewStore.send(.quickMode(0)) }) {Text("USB")}
        Button(action: { viewStore.send(.quickMode(1)) }) {Text("LSB")}
        Button(action: { viewStore.send(.quickMode(2)) }) {Text("CW")}
      }.frame(width: width)
      
      GridRow {
        Button(action: { viewStore.send(.filter(0)) }) {Text("1.0k")}
        Button(action: { viewStore.send(.filter(1)) }) {Text("1.2k")}
        Button(action: { viewStore.send(.filter(2)) }) {Text("1.4k")}
        Button(action: { viewStore.send(.filter(3)) }) {Text("1.6k")}
        Button(action: { viewStore.send(.filter(4)) }) {Text("1.8k")}
      }.frame(width: width)
      
      GridRow {
        Button(action: { viewStore.send(.filter(5)) }) {Text("2.0k")}
        Button(action: { viewStore.send(.filter(6)) }) {Text("2.2k")}
        Button(action: { viewStore.send(.filter(7)) }) {Text("2.4k")}
        Button(action: { viewStore.send(.filter(8)) }) {Text("2.6k")}
        Button(action: { viewStore.send(.filter(9)) }) {Text("2.8k")}
      }.frame(width: width)
    }
    .frame(height: 100)
    Divider().background(.blue)
  }
}

private struct XritView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  
  let buttonWidth: CGFloat = 40
  
  var body: some View {
    
    Grid(horizontalSpacing: 15) {
      GridRow {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.ritEnabled},
          send: { .sliceProperty(slice, .ritEnabled, $0.as1or0) })) { Text("RIT").frame(width: buttonWidth) }
          .toggleStyle(.button)

        HStack(spacing: 5) {
          Image(systemName: "plus.square").font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .ritOffset, String(slice.ritOffset + 10)))
            }
          ApiIntView(hint: "rit", value: slice.ritOffset, action: { viewStore.send(.sliceProperty(slice, .ritOffset, String($0))) }, width: 50)
          Image(systemName: "minus.square").font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .ritOffset, String(slice.ritOffset - 10)))
            }
        }
        Button(action: { viewStore.send(.sliceProperty(slice, .ritOffset, "0")) }, label: { Text("Clear").frame(width: buttonWidth) })
      }
      GridRow {
        Toggle(isOn: viewStore.binding(
          get: {_ in slice.xitEnabled},
          send: { .sliceProperty(slice, .xitEnabled, $0.as1or0) })) { Text("XIT").frame(width: buttonWidth) }
          .toggleStyle(.button)

        HStack(spacing: 5) {
          Image(systemName: "plus.square").font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .xitOffset, String(slice.xitOffset + 10)))
            }
          ApiIntView(hint: "xit", value: slice.xitOffset, action: { viewStore.send(.sliceProperty(slice, .xitOffset, String($0))) }, width: 50)
          Image(systemName: "minus.square").font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .xitOffset, String(slice.xitOffset - 10)))
            }
        }
        Button(action: { viewStore.send(.sliceProperty(slice, .xitOffset, "0")) }, label: { Text("Clear").frame(width: buttonWidth) })
      }
      GridRow {
        Text("Tuning step")
        HStack(spacing: 5) {
          Image(systemName: "plus.square").font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .step, String(slice.step + 10)))
            }
          ApiIntView(hint: "step", value: slice.step, action: { viewStore.send(.sliceProperty(slice, .step, String($0))) }, width: 50)
          Image(systemName: "minus.square").font(.title2)
            .onTapGesture {
              viewStore.send(.sliceProperty(slice, .step, String(slice.step - 10)))
            }
        }

        //                        .modifier(ClearButton(boundText: $tuningStepString, trailing: false))
//        Stepper("", value: viewStore.binding(
//          get: {_ in slice.step},
//          send: { .sliceSetAndSend(slice, .step, String($0)) } ), in: 0...100000)
      }
    }
    .frame(height: 100)
    Divider().background(.blue)
  }
}

/*
 Image(systemName: "x.circle")
   .onTapGesture {
     viewStore.send(.sliceSetAndSend(slice, .ritOffset, "0"))
   }

 */


private struct DaxView: View {
  let viewStore: ViewStore<FlagFeature.State, FlagFeature.Action>
  @ObservedObject var slice: Slice
  
  var body: some View {
    VStack {
      Picker("DAX Channel", selection: viewStore.binding(
        get: {_ in slice.daxChannel },
        send: { .sliceProperty(slice, .daxChannel, String($0)) } )) {
          ForEach(Radio.kDaxChannels, id: \.self) {
            Text("\($0 == 0 ? "None" : String($0))").tag($0)
          }
        }.frame(width: 200)
    }
    .frame(height: 100)
    Divider().background(.blue)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview(s)

struct FlagView_Previews: PreviewProvider {
  
  static var previews: some View {
    FlagView(store: Store(initialState: FlagFeature.State(),
                          reducer: FlagFeature()))
    .frame(width: 275)
  }
}

//extension NumberFormatter {
//  static let dotted: NumberFormatter = {
//    let formatter = NumberFormatter()
//    formatter.groupingSeparator = "."
//    formatter.numberStyle = .decimal
//    return formatter
//  }()
//}
//
//extension String {
//  var isValidFrequency: Bool {
//    let digitsCharacters = CharacterSet(charactersIn: "0123456789.")
//    return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters) && self.filter{ $0 == "."}.count <= 1
//  }
//}
