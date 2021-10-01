//
//  CercTripView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import SwiftUI

struct CercTripItemView: View {
    @Environment(\.tintColor) var tintColor
    
    @EnvironmentObject var controller: CercController

    @State private var isExpanded: Bool = false

    @ScaledMetric private var baseTextWidth:  Double =  50
    @ScaledMetric private var baseLineWidth:  Double =  80
    @ScaledMetric private var baseLineHeight: Double =   3
    @ScaledMetric private var baseDotSize:    Double =  12

    let tripSet: TripSet

    private var origin: Station? {
        guard let id = tripSet.trips.first?.originID else { return nil }

        return controller.stations.first { $0.id == id }
    }

    private var destination: Station? {
        guard let id = tripSet.trips.first?.destinationID else { return nil }

        return controller.stations.first { $0.id == id }
    }

    private var transfers: [Station] {
        guard let first = tripSet.trips.first else { return [] }

        let ids = first.transfers.map { $0.stationID }

        return controller.stations.filter { ids.contains($0.id) }
    }

    private var extraDeparturesLabel: LocalizedStringKey? {
        tripSet.kind == .sameArrival && tripSet.trips.count > 1
            ? .init("+\(tripSet.trips.count - 1)")
            : nil
    }

    private var extraArrivalsLabel: LocalizedStringKey? {
        tripSet.kind == .sameDeparture && tripSet.trips.count > 1
            ? .init("+\(tripSet.trips.count - 1)")
            : nil
    }

    private var drawingColor: Color {
        return tintColor.lighten(by: 40)
    }

    private var isCivis: Bool {
        guard let first = tripSet.trips.first else { return false }

        return first.isCivis
    }

    private var isAccessible: Bool {
        guard let first = tripSet.trips.first else { return false }

        return first.isAccessible
    }

    var body: some View {
        CercListItem(padding: 0, tint: tintColor) {
            VStack {
                TripHeader()
                    .padding(.horizontal)

                if isExpanded {
                    Divider()
                        .background(tintColor.opacity(0.2))

                    ScrollView(.horizontal) {
                        TripBody()
                            .padding(.horizontal)
                    }

                    if isCivis || isAccessible {
                        Divider()
                            .background(tintColor.opacity(0.2))
                        HStack {
                            if isAccessible {
                                Label("Accessible", image: "wheelchair")
                            }
                            if isCivis {
                                Label("CIVIS", image: "zap")
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.25)) { isExpanded.toggle() }
        }
    }

    private func TripHeader() -> some View {
        HStack {
            if isExpanded {
                if let time = tripSet.trips.first?.relativeTimeString() {
                    Text(time)
                }
            } else {
                if let first = tripSet.trips.first {
                    Text(first.departureString)
                        .frame(width: baseTextWidth)
                        .cercBackground()
                        .badge(extraDeparturesLabel, color: tintColor.lighten(by: 40))
                    Text("-")
                    Text(first.arrivalString)
                        .frame(width: baseTextWidth)
                        .cercBackground()
                        .badge(extraArrivalsLabel, color: tintColor.lighten(by: 40))
                }
            }

            Spacer()
            Image(systemName: "chevron.right")
                .rotationEffect(isExpanded ? .degrees(90) : .degrees(0))
                .cercBackground()
        }
    }

    @ViewBuilder
    private func TripBody() -> some View {
        HStack {
            VStack {// These two stacks make it so that all the inner HStacks take the same width
                // Station names
                HStack {
                    Text((origin?.name ?? "??"))
                        .font(.caption)
                        .frame(width: baseTextWidth, alignment: .leading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    Spacer()

                    ForEach(transfers) { transfer in
                        Text(transfer.name)
                            .font(.caption)
                            .frame(maxWidth: 2*baseTextWidth, alignment: .center)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Spacer()
                    }

                    Text((destination?.name ?? ""))
                        .font(.caption)
                        .frame(width: baseTextWidth, alignment: .trailing)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }

                if tripSet.kind == .sameDeparture {
                    // Main Drawing and times
                    TripBodyTripSection(tripSet.trips.first!)

                    // Rest of drawing and times
                    ForEach(1..<tripSet.trips.count) { index in
                        TripBodyTripSection(tripSet.trips[index], kind: .sameDeparture)
                    }
                } else {
                    // Rest of drawing and times
                    ForEach(0..<(tripSet.trips.count - 1)) { index in
                        TripBodyTripSection(tripSet.trips[index], kind: .sameArrival)
                    }

                    // Main Drawing and times
                    TripBodyTripSection(tripSet.trips.last!)
                }
            }
        }
        .frame(minWidth: UIScreen.screenWidth - 4*16)
        .padding(.bottom) // adds space between content and scrollbar
    }

    @ViewBuilder
    private func TripBodyTripSection(_ trip: Trip, kind: TripSet.Kind? = nil) -> some View {
        ZStack {
            HStack(spacing: 0) {
                Circle()
                    .fill(drawingColor)
                    .frame(width: baseDotSize, height: baseDotSize)
                    .padding(.trailing, baseDotSize/2)
                    .opacity(
                        kind == nil ? 1.0
                            : kind == .sameArrival ? 1.0 : 0.0
                    )

                if trip.transfers.count < 1 {
                    RoundedRectangle(cornerRadius: baseLineHeight/2, style: .continuous)
                        .fill(drawingColor)
                        .frame(width: 3*baseLineWidth, height: baseLineHeight)
                        .overlay(
                            Text(trip.line)
                                .font(.caption)
                                .offset(y: -baseDotSize)
                        )
                } else {
                    ForEach(0..<trip.transfers.count) { index in
                        if index == 0 {
                            RoundedRectangle(cornerRadius: baseLineHeight/2, style: .continuous)
                                .fill(drawingColor)
                                .frame(width: baseLineWidth, height: baseLineHeight)
                                .overlay(
                                    Text(trip.line)
                                        .font(.caption)
                                        .offset(y: -baseDotSize)
                                )
                                .opacity(
                                    kind == nil ? 1.0
                                        : kind == .sameArrival ? 1.0 : 0.0
                                )
                        }
                        Circle()
                            .fill(drawingColor)
                            .frame(width: baseDotSize, height: baseDotSize)
                            .padding(.leading, baseDotSize)
                            .padding(.trailing, baseDotSize/4)
                            .opacity(
                                kind == nil ? 1.0
                                    : kind == .sameArrival ? 1.0 : 0.0
                            )
                        Spacer()
                            .frame(width: baseTextWidth/2)
                        Circle()
                            .fill(drawingColor)
                            .frame(width: baseDotSize, height: baseDotSize)
                            .padding(.leading, baseDotSize/4)
                            .padding(.trailing, baseDotSize)
                            .opacity(
                                kind == nil ? 1.0
                                    : kind == .sameDeparture ? 1.0 : 0.0
                            )
                        RoundedRectangle(cornerRadius: baseLineHeight/2, style: .continuous)
                            .fill(drawingColor)
                            .frame(width: baseLineWidth, height: baseLineHeight)
                            .overlay(
                                Text(trip.transfers[index].line)
                                    .font(.caption)
                                    .offset(y: -baseDotSize)
                            )
                            .opacity(
                                kind == nil ? 1.0
                                    : kind == .sameDeparture ? 1.0 : 0.0
                            )
                    }
                }
                Circle()
                    .fill(drawingColor)
                    .frame(width: baseDotSize, height: baseDotSize)
                    .padding(.leading, baseDotSize/2)
                    .opacity(
                        kind == nil ? 1.0
                            : kind == .sameDeparture ? 1.0 : 0.0
                    )
            }

            if trip.transfers.count > 0 {
                HStack(spacing: 0) {
                    Spacer()

                    ForEach(trip.transfers) { _ in
                        Ellipse()
                            .stroke(drawingColor, lineWidth: baseLineHeight)
                            .frame(width: (6*baseDotSize), height: (3*baseDotSize))
                            .opacity(
                                kind == nil ? 1.0 : 0
                            )
                        Spacer()
                    }
                }
                .padding(.horizontal, 1.2*baseDotSize)
            }
        }

        HStack(spacing: 0) {
            Text(trip.departureString)
                .font(.caption)
                .opacity(
                    kind == nil ? 1.0
                        : kind == .sameArrival ? 1.0 : 0.0
                )
            Spacer()

            ForEach(trip.transfers) { transfer in
                Text(transfer.arrivalString)
                    .font(.caption)
                    .padding(.trailing, 1.5*baseDotSize)
                    .opacity(
                        kind == nil ? 1.0
                            : kind == .sameArrival ? 1.0 : 0.0
                    )
                Text(transfer.departureString)
                    .font(.caption)
                    .padding(.leading, 1.5*baseDotSize)
                    .opacity(
                        kind == nil ? 1.0
                            : kind == .sameDeparture ? 1.0 : 0.0
                    )
                Spacer()
            }

            Text(trip.arrivalString)
                .font(.caption)
                .opacity(
                    kind == nil ? 1.0
                        : kind == .sameDeparture ? 1.0 : 0.0
                )
        }
    }
}

struct CercTripView: View {
    @Environment(\.tintColor) var tintColor

    @EnvironmentObject var controller: CercController

    private var tripSets: [TripSet] {
        return (controller.trips ?? [])
            .filter { tripSet in
                guard let first = tripSet.trips.first,
                      let departure = first.departure() else { return false }

                return departure >= .now
            }
            .sorted()
    }

    var body: some View {
        switch controller.state {
        case .loadingTrips:
            CercListItem(tint: tintColor) {
                Image(systemName: "network")
                Text("Loading...")
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
            }
            .onReceive(controller.$error) { error in
                if error != nil {
                    print("ERROR")
                    controller.state = .normal
                }
            }
        default:
            if let search = controller.tripSearch {
                HStack {
                    Image(systemName: "tram")
                    Text(search.origin.name)
                    Image(systemName: "arrow.right")
                    Text(search.destination.name)
                    Spacer()
                }
                .font(.body.bold())
                .padding(.leading, 6)
                .foregroundColor(tintColor)

                ForEach(tripSets) { tripSet in
                    CercTripItemView(tripSet: tripSet)
                }
            } else {
                CercListItem(tint: tintColor) {
                    Image(systemName: "exclamationmark.octagon")
                    Text("Search for a trip")
                    Spacer()
                }
            }
        }
    }
}

struct CercTripView_Previews: PreviewProvider {
    static var previews: some View {
        CercTripView()
    }
}
