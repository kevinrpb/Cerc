//
//  CercSettingsView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import SwiftUI

struct CercSettingsView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.tintColor) var tintColor

    @Binding var settings: Settings

    var body: some View {
        SettingsHeader("Colors", image: "paintpalette")
        ColorsSection()
        Spacer(minLength: 30)
        SettingsHeader("Links", image: "link")
        LinksSection()
        Spacer(minLength: 30)
        SettingsHeader("Third Party Software", image: "doc.text")
        LicensesSection()
        Spacer(minLength: 30)
    }

    private func ColorsSection() -> some View {
        CercListItem(tint: tintColor) {
            VStack {
                HStack {
                    Text("Tint Color")
                    Spacer()
                    Picker(selection: $settings.tintColorKey) {
                        ForEach(Color.keys, id: \.self) { colorKey in
                            Text(colorKey.capitalized)
                        }
                    } label: {
                        Button {} label: {
                            HStack {
                                Circle()
                                    .fill(tintColor)
                                    .frame(width: 20, height: 20)
                                Text(settings.tintColorKey.capitalized)
                                Text("AAA")
                            }
                        }
                        .buttonStyle(CercButtonStyle(tintColor))
                    }
                    .pickerStyle(.menu)
                }
            }
        }
    }

    private func LinksSection() -> some View {
        CercListItem(tint: tintColor) {
            VStack {
                HStack {
                    Label("Website", systemImage: "network")
                    Spacer()
                    Button {
                        openURL(.init(string: "https://kevinrpb.me")!)
                    } label: {
                        Text("kevinrpb.me")
                    }
                    .buttonStyle(CercButtonStyle(tintColor))
                }
                HStack {
                    Label("GitHub", image: "github")
                    Spacer()
                    Button {
                        openURL(.init(string: "https://github.com/kevinrpb")!)
                    } label: {
                        Text("kevinrpb")
                    }
                    .buttonStyle(CercButtonStyle(tintColor))
                }
                HStack {
                    Label("Twitter", image: "twitter")
                    Spacer()
                    Button {
                        openURL(.init(string: "https://twitter.com/kevinrpb")!)
                    } label: {
                        Text("@kevinrpb")
                    }
                    .buttonStyle(CercButtonStyle(tintColor))
                }
            }
        }
    }

    private func LicensesSection() -> some View {
        CercListItem(tint: tintColor) {
            VStack {
                HStack {
                    Text("Defaults (Sindre Sorhus)")
                    Spacer()
                    Button("MIT") {
                        openURL(.init(string: "https://github.com/sindresorhus/Defaults")!)
                    }
                    .buttonStyle(CercButtonStyle(tintColor))
                }
            }
        }
    }

    private func SettingsHeader(_ title: String, image: String) -> some View {
        HStack {
            Label(title, systemImage: image)
                .font(.body.bold())
                .padding(.leading, 6)
            Spacer()
        }
        .foregroundColor(tintColor)
    }
}

struct CercSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CercSettingsView(settings: .constant(.base))
    }
}
