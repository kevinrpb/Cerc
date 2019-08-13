//
//  MainContentView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

enum DisplayingModal {
    case none, zones, origin, destination, date, trip
}

struct MainContentView: View {

    @EnvironmentObject var store: CercStore

    @State var modal: DisplayingModal = .none {
        willSet {
            self.displayModal = newValue != .none
        }
    }
    @State var displayModal: Bool = false

    // MARK: - Body

    var body: some View {
        LoadingView(isLoading: $store.loading) {
            VStack {
                self.Header()
                self.Picks()
                    .padding(.vertical, 40)
                self.SubmitButton()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            self.store.loadAll()
            self.fake()
        }
        .sheet(isPresented: $displayModal) {
            if self.modal == .zones {
                ZoneSelectionList { zone in
//                    self.store.selectZone(zone.id)
                    self.fake()
                    self.modal = .none
                }
                .environmentObject(self.store)
            } else if self.modal == .origin {
                StationSelectionList { station in
                    self.store.selectOrigin(station.id)
                    self.modal = .none
                }
                .environmentObject(self.store)
            } else if self.modal == .destination {
                StationSelectionList { station in
                    self.store.selectDestination(station.id)
                    self.modal = .none
                }
                .environmentObject(self.store)
            } else if self.modal == .date {
                EmptyView()
                    .onAppear { self.modal = .none }
            } else if self.modal == .trip {
                TripView()
                    .environmentObject(self.store)
            } else {
                EmptyView()
                    .onAppear { self.modal = .none }
            }
        }
    }

    func fake() {
        store.selectZone("10")
        store.selectOrigin("10202")
        store.selectDestination("70003")
    }

}

// MARK: - Header

extension MainContentView {

    @ViewBuilder
    func Header() -> some View {
        HStack {
            Image("CercHeader")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(height: 48)
        .padding(.bottom, 18)
    }

}

// MARK: - Pick Buttons

extension MainContentView {

    @ViewBuilder
    func Picks() -> some View {
        VStack(spacing: 30) {
            ZonePick()
            OriginPick()
            DestinationPick()
            DatePick()
        }
    }

    @ViewBuilder
    func ZonePick() -> some View {
        PickButton(pickType: .zone, label: "Zone") {
            self.modal = .zones
        }
    }

    @ViewBuilder
    func OriginPick() -> some View {
        PickButton(pickType: .origin, label: "Origin") {
            self.modal = .origin
        }
    }

    @ViewBuilder
    func DestinationPick() -> some View {
        PickButton(pickType: .destination, label: "Destination") {
            self.modal = .destination
        }
    }

    @ViewBuilder
    func DatePick() -> some View {
        PickButton(pickType: .date, label: "Date") {
//            self.modal = .date
        }
    }

}

// MARK: - SubmitButton

extension MainContentView {

    var shouldShowSubmit: Bool {
        return store.selectedZone != nil && store.selectedOrigin != nil && store.selectedDestination != nil
    }

    @ViewBuilder
    func SubmitButton() -> some View {
        RoundButton(action: self.submit) {
            Text("Get Times")
        }
        .scaleEffect(self.shouldShowSubmit ? 1 : 0)
        .opacity(self.shouldShowSubmit ? 1 : 0)
        .animation(Animation.interactiveSpring().delay(0.3))
    }

    func submit() {
        store.loadTrip {
            self.modal = .trip
        }
    }

}
