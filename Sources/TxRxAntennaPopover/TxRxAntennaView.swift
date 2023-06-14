//
//  TxRxAntennaView.swift
//  
//
//  Created by Douglas Adams on 6/12/23.
//

import ComposableArchitecture
import SwiftUI

import FlexApi

public struct TxRxAntennaView: View {
  let store: StoreOf<TxRxAntenna>
  @ObservedObject var slice: Slice
  
  public init(store: StoreOf<TxRxAntenna>, slice: Slice) {
    self.store = store
    self.slice = slice
  }
  
  @Dependency(\.apiModel) var apiModel
  @Dependency(\.objectModel) var objectModel

  var panadapter: Panadapter { objectModel.panadapters[id: slice.panadapterId]! }
  
  public var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        HStack {
          Text("Tx Antenna").frame(alignment: .leading)
          Picker("", selection: viewStore.binding(
            get: {_ in slice.txAnt},
            send: { .txChoice(slice, $0) })) {
              ForEach(slice.txAntList, id: \.self) {
                Text(apiModel.altAntennaName(for: $0)).tag($0)
              }
            }
            .labelsHidden()
        }
        Divider().background(Color(.blue))
        HStack {
          Text("Rx Antenna").frame(alignment: .leading)
          Picker("", selection: viewStore.binding(
            get: {_ in slice.rxAnt},
            send: { .rxChoice(slice, $0) })) {
              ForEach(slice.rxAntList, id: \.self) {
                Text(apiModel.altAntennaName(for: $0)).tag($0)
              }
            }
            .labelsHidden()
        }
        HStack {
          Spacer()
          Toggle("Loop A", isOn: viewStore.binding(
            get: {_ in panadapter.loopAEnabled },
            send: { .panadapterProperty(panadapter, .loopAEnabled, $0.as1or0 ) } ))
          .toggleStyle(.button)
        }

        HStack {
          Text("Rf Gain")
          Text("\(panadapter.rfGain)").frame(width: 25, alignment: .trailing)
          Slider(value: viewStore.binding(get: {_ in Double(panadapter.rfGain) }, send: { .panadapterProperty(panadapter, .rfGain, String(Int($0))) }), in: -10...20, step: 10)
        }
      }
      .padding()
    }
  }
}

struct TxRxAntennaView_Previews: PreviewProvider {
  static var previews: some View {
    TxRxAntennaView(store: Store(initialState: TxRxAntenna.State(), reducer: TxRxAntenna()),
//                    panadapter: Panadapter(0x49999990),
                    slice: Slice(1))
    .frame(width: 200)
  }
}
