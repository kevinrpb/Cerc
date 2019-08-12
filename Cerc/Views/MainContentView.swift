//
//  MainContentView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

enum DisplayingModal {
    case none, zones, origin, destination
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
        ZStack(alignment: .top) {
            VStack {
                Header()
                Picks()
                    .padding(.vertical, 40)
                SubmitButton()
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
//            if self.store.selectedZone == nil {
//                self.store.selectZone("10")
//            } else {
//                self.store.clearZone()
//            }
            self.modal = .zones
        }
    }

    @ViewBuilder
    func OriginPick() -> some View {
        PickButton(pickType: .origin, label: "Origin") {
//            if self.store.selectedOrigin == nil {
//                self.store.selectOrigin("10202")
//            } else {
//                self.store.clearOrigin()
//            }
            self.modal = .origin
        }
    }

    @ViewBuilder
    func DestinationPick() -> some View {
        PickButton(pickType: .destination, label: "Destination") {
//            if self.store.selectedDestination == nil {
//                self.store.selectDestination("10203")
//            } else {
//                self.store.clearDestination()
//            }
            self.modal = .destination
        }
    }

    @ViewBuilder
    func DatePick() -> some View {
        PickButton(pickType: .date, label: "Date") {

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
        RoundButton(action: self.loadTrip) {
            Text("Get Times")
        }
        .scaleEffect(self.shouldShowSubmit ? 1 : 0)
        .opacity(self.shouldShowSubmit ? 1 : 0)
        .animation(.interactiveSpring())
    }

    // MARK: Functions

    func loadTrip() {
        let request = CercTripRequest(core: store.selectedZone?.id ?? "",
                                      origin: store.selectedOrigin?.id ?? "",
                                      destination: store.selectedDestination?.id ?? "",
                                      date: store.selectedDate.cercString)

        APIService.shared.load(.trip(request)) { (result: Result<CercTrip, APIService.APIError>) in
            print(result)
        }
    }

}
