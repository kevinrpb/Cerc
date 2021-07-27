//
//  CercSelectionView.swift
//  CercSelectionView
//
//  Created by Kevin Romero Peces-Barba on 27/7/21.
//

import SwiftUI

struct CercSelectionView<Element, ElementLabel>: View where Element: Identifiable & Nameable, ElementLabel: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.tintColor) var tintColor

    let title: String

    @Binding var selected: Element?
    @Binding var elements: [Element]

    let dismissOnSelect: Bool

    private let onSelect: ((Element?) -> Void)?
    private let labelProvider: (Element) -> ElementLabel

    @State private var searchText: String = ""

    init(title: String, selected: Binding<Element?>, elements: Binding<[Element]>, dismissOnSelect: Bool = true, onSelect: ((Element?) -> Void)? = nil,
         labelProvider: @escaping (Element) -> ElementLabel) {
        self.title = title
        self._selected = selected
        self._elements = elements
        self.dismissOnSelect = dismissOnSelect
        self.onSelect = onSelect
        self.labelProvider = labelProvider
    }

    init(title: String, selected: Binding<Element>, elements: Binding<[Element]>, dismissOnSelect: Bool = true, onSelect: ((Element?) -> Void)? = nil,
         labelProvider: @escaping (Element) -> ElementLabel) {
        self.title = title
        self._selected = .init(selected)
        self._elements = elements
        self.dismissOnSelect = dismissOnSelect
        self.onSelect = onSelect
        self.labelProvider = labelProvider
    }

    private var searchResults: [Element] {
        searchText
//            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty ? elements : elements.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
    }

    var body: some View {
        ScrollView {
            VStack {
                if elements.isEmpty {
                    CercListItem(tint: tintColor) {
                        Image(systemName: "exclamationmark.octagon")
                        Spacer()
                        Text("Oops! There are no zones! Try refreshing?")
                    }
                    .foregroundColor(.red)
                } else {
                    CercListItem(tint: tintColor) {
                        TextField("Search", text: $searchText)
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.bottom)
                    ForEach(searchResults) { element in
                        CercListItem(tint: tintColor) {
                            labelProvider(element)
                            Spacer()
                            Button {
                                selected = element

                                if let onSelect = onSelect {
                                    onSelect(element)
                                }

                                if dismissOnSelect {
                                    dismiss()
                                }
                            } label: {
                                Text("Select")
                            }
                            .buttonStyle(CercButtonStyle())
                        }
                    }
                }
            }.padding()
        }
        .background(tintColor.opacity(0.1))
        .navigationTitle("App Icon")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }

    private func BackButton() -> some View {
        Button(action: { dismiss() }) {
            Label("Back", systemImage: "chevron.left")
        }
        .buttonStyle(CercNavButtonStyle(tintColor))
    }
}

