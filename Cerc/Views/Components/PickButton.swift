//
//  PickButton.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/27/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

// MARK: - PickButton

enum PickType {
    case zone, origin, destination, date
}

struct PickButton: View {

    @EnvironmentObject var store: CercStore

    private var shouldShow: Bool {
        switch pickType {
        case .zone:        return true
        case .origin,
             .destination: return store.selectedZone != nil
        case .date:        return store.selectedZone != nil && store.selectedOrigin != nil && store.selectedDestination != nil
        }
    }

    private var isSet: Bool {
        switch pickType {
        case .zone:        return store.selectedZone != nil
        case .origin:      return store.selectedOrigin != nil
        case .destination: return store.selectedDestination != nil
        case .date:        return true
        }
    }

    private var title: String {
        switch pickType {
        case .zone:        return store.selectedZone?.name ?? ""
        case .origin:      return store.selectedOrigin?.name ?? ""
        case .destination: return store.selectedDestination?.name ?? ""
        case .date:        return store.selectedDate.simpleString
        }
    }

    let pickType: PickType
    let label: String
    let action: () -> Void

    @ViewBuilder
    func ButtonContent() -> some View {
        if isSet {
            PickButtonSet(title: title)
        } else {
            PickButtonUnset()
        }
    }

    var body: some View {
        VStack(spacing: 5) {
            Text(self.label)
            Button(action: self.action, label: {
                self.ButtonContent()
                    .frame(width: 200, height: 40, alignment: .center)
                    .background(PickButtonBackground(isSet: isSet))
            })
        }
        .scaleEffect(self.shouldShow ? 1 : 0)
        .opacity(self.shouldShow ? 1 : 0)
        .animation(Animation.interactiveSpring().delay(0.3))
    }

}


// MARK: - Base PickButton

fileprivate struct PickButtonSet: View {

    let title: String
    let color: Color

    init(title: String, color: Color = .white) {
        self.title = title
        self.color = color
    }

    var body: some View {
        Text(title)
            .foregroundColor(color)
    }

}

fileprivate struct PickButtonUnset: View {

    let color: Color

    init(color: Color = .white) {
        self.color = color
    }

    @ViewBuilder
    func Circ() -> some View {
        Circle()
            .fill(color)
            .padding(10)
    }

    var body: some View {
        HStack {
            Circ()
            Circ()
            Circ()
        }
    }

}

fileprivate struct PickButtonBackground: View {

    let isSet: Bool
    let colorSet: Color
    let colorUnset: Color

    init(isSet: Bool, colorSet: Color = .blue, colorUnset: Color = .gray) {
        self.isSet = isSet
        self.colorSet = colorSet
        self.colorUnset = colorUnset
    }

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: geometry.size.height / 2)
                .fill(self.isSet ? self.colorSet : self.colorUnset)
        }
    }

}
