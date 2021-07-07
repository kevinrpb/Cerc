//
//  CercIconSelectionView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/7/21.
//

import SwiftUI

struct CercIconSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.tintColor) var tintColor

    @Binding var settings: Settings
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(AppIcon.allCases) { appIcon in
                    CercListItem(tint: tintColor) {
                        Image(uiImage: appIcon.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .mask(RoundedRectangle(cornerRadius: 8.8, style: .continuous))
                        Text(appIcon.name)
                        Spacer()
                        Button("Select") {
                            settings.setAppIcon(appIcon)
                        }.cercBackground()
                    }
                }
                Spacer()
            }
            .padding()
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
