//
//  CompactLayoutView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

extension CercController.State {
    static let withSheet: [Self] = [
        .settings,
        .loadingTrips,
        .displayingTrips
    ]

    static let tripRelated: [Self] = [
        .loadingTrips,
        .displayingTrips
    ]
}

struct CompactLayoutView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.tintColor) var tintColor

    @EnvironmentObject var controller: CercController

    @State private var showSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                CercFormView()
                    .environmentObject(controller)
                    .environment(\.tintColor, tintColor)
            }
            .padding()
        }
        .background(tintColor.opacity(0.1))
        .navigationTitle("Cerc")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
            HStack {
                SettingsButton()
                RefreshButton()
            }
        , trailing:
            HStack {
                SearchButton()
            }
        )
        .sheet(isPresented: $showSheet) {
            if CercState.withSheet.contains(controller.state) {
                controller.state = .normal
            }
        } content: {
            NavigationView() {
                ScrollView {
                    VStack {
                        SheetContent(for: controller.state)
                            .environment(\.tintColor, tintColor)
                    }
                    .padding()
                }
                .background(tintColor.opacity(0.1))
                .navigationTitle(SheetTitle(for: controller.state))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: CloseSheetButton())
            }
        }
        .onChange(of: controller.state) { newState in
            guard CercState.withSheet.contains(newState) else {
                showSheet = false
                return
            }

            if CercState.tripRelated.contains(newState) {
                showSheet = horizontalSizeClass == .compact
            } else {
                showSheet = true
            }
        }
        .onAppear {
            Task {
                await controller.loadData()
                #if DEBUG
                if let origin = controller.stations.first(where: { $0.id == "70003" }),
                   let destination = controller.stations.first(where: { $0.id == "10202" }) {
                    controller.origin = origin
                    controller.destination = destination
//                    await controller.startSearch()
                }
                #endif
            }
        }
    }

    @ViewBuilder
    private func SheetContent(for state: CercController.State) -> some View {
        switch state {
        case .settings:
            CercSettingsView(settings: $controller.settings)
        case .loadingTrips, .displayingTrips:
            CercTripView()
                .environmentObject(controller)
        default:
            EmptyView()
        }
    }

    private func SheetTitle(for state: CercController.State) -> String {
        switch state {
        case .settings:
            return "Settings"
        case .loadingTrips, .displayingTrips:
            return "Trip"
        default:
            return ""
        }
    }

    private func SettingsButton() -> some View {
        Button {
            controller.state = .settings
        } label: {
            Label("Settings", systemImage: "gearshape")
        }
        .buttonStyle(CercNavButtonStyle(tintColor))
    }

    private func RefreshButton() -> some View {
        Button {
            Task { await controller.loadData(force: true) }
        } label: {
            Label("Refresh", systemImage: "arrow.triangle.2.circlepath")
        }
        .buttonStyle(CercNavButtonStyle(tintColor))
    }

    private func SearchButton() -> some View {
        Button {
            Task { await controller.startSearch() }
        } label: {
            Label("Search", systemImage: "magnifyingglass")
                .labelStyle(.titleAndIcon)
                .padding(.trailing, 2) // otherwise it looks kinda odd...
        }
        .buttonStyle(CercNavButtonStyle(tintColor, fluid: true))
    }

    private func CloseSheetButton() -> some View {
        Button {
            showSheet = false
        } label: {
            Label("Close", systemImage: "xmark")
        }
        .buttonStyle(CercNavButtonStyle(tintColor))
    }
}

struct CompactLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        CompactLayoutView()
    }
}
