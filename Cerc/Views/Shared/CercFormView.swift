//
//  CercFormView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

struct CercFormView: View {
    @Environment(\.tintColor) var tintColor

    @EnvironmentObject var controller: CercController

    var body: some View {
        if controller.state == .loading {
            CercListItem(tint: tintColor) {
                Image(systemName: "network")
                Text("Loading...")
                Spacer()
            }
            Spacer(minLength: 30)
        } else {
            if let error = controller.error {
                CercListItem(tint: tintColor) {
                    Image(systemName: "exclamationmark.octagon")
                    Text(error.description)
                        .textSelection(.enabled)
                    Spacer()
                }
                .foregroundColor(.red)
                Spacer(minLength: 30)
            }
            Form()
        }
    }

    @ViewBuilder
    private func Form() -> some View {
        FormHeader("Location", image: "map")
        CercListItem(tint: tintColor) {
            FormSelector("Zone", badge: controller.zone?.name ?? "Select") {
//                CercZoneSelectionView(selected: $controller.zone, zones: $controller.zones)
                CercSelectionView(title: "Zone", selected: $controller.zone, elements: $controller.zones) { zone in
                    Text(zone.name)
                }
            }
        }
        Spacer(minLength: 30)

        FormHeader("Stations", image: "tram")
        CercListItem(tint: tintColor) {
            VStack {
                FormSelector("Origin", badge: controller.origin?.name ?? "Select") {
                    CercSelectionView(title: "Origin", selected: $controller.origin, elements: $controller.displayedStations) { station in
                        Text(station.name)
                    }
                }
                FormSelector("Destination", badge: controller.destination?.name ?? "Select") {
                    CercSelectionView(title: "Destination", selected: $controller.destination, elements: $controller.displayedStations) { station in
                        Text(station.name)
                    }
                }
            }
        }
        Spacer(minLength: 30)

        FormHeader("Date and time", image: "clock")
        CercListItem(tint: tintColor) {
            VStack {
                FormPicker("Date") {
                    DatePicker("Date",
                               selection: $controller.date,
                               in: Date.now...Date.now.addingTimeInterval(.init(1209600)), // 14*(24*60*60) (14 days)
                               displayedComponents: [.date])
                        .accentColor(tintColor)
                }
//                FormPicker("Between") {
//                    DatePicker("Between",
//                               selection: $controller.hourStart,
//                               in: controller.date.dayRange,
//                               displayedComponents: [.hourAndMinute])
//                        .accentColor(tintColor)
//                }
//                FormPicker("And") {
//                    DatePicker("And",
//                               selection: $controller.hourEnd,
//                               in: controller.hourStart...controller.date.endOfDay,
//                               displayedComponents: [.hourAndMinute])
//                        .accentColor(tintColor)
//                }
            }
        }
        Spacer(minLength: 30)
    }

    private func FormHeader(_ title: String, image: String) -> some View {
        HStack(alignment: .center) {
            Label(title, systemImage: image)
                .font(.body.bold())
                .padding(.leading, 6)
            Spacer()
        }
        .foregroundColor(tintColor)
    }

    private func FormSelector<Content: View>(_ title: String, badge: String,
                                             destination: @escaping () -> Content) -> some View {
        HStack {
            Text(title)
            Spacer()
            NavigationLink(destination: destination) {
                Text(badge)
                    .foregroundColor(.primary)
            }
            .cercBackground()
        }
    }

    private func FormPicker<Content: View>(_ title: String, Picker: @escaping () -> Content) -> some View {
        HStack {
            Text(title)
            Spacer()
            Picker()
                .datePickerStyle(.compact)
                .labelsHidden()
                .foregroundColor(.purple)
                .accentColor(.purple)
            // I'd love to use this background but it doesn't work as expected :/
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.purple)
//                        .opacity(0.2)
//                )
        }
    }
}

struct CercFormView_Previews: PreviewProvider {
    static var previews: some View {
        CercFormView()
    }
}
