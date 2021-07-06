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
        SettingsHeader("Licenses", image: "doc.text")
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
                    Text("Website")
                    Spacer()
                    Button {
                        openURL(.init(string: "https://kevinrpb.me")!)
                    } label: {
                        Label("kevinrpb.me", systemImage: "network")
                    }
                    .buttonStyle(CercButtonStyle(tintColor))
                }
                HStack {
                    Text("GitHub")
                    Spacer()
                    Button {
                        openURL(.init(string: "https://github.com/kevinrpb")!)
                    } label: {
                        Label("kevinrpb", systemImage: "github")
                    }
                    .buttonStyle(CercButtonStyle(tintColor))
                }
                HStack {
                    Text("Twitter")
                    Spacer()
                    Button {
                        openURL(.init(string: "https://twitter.com/kevinrpb")!)
                    } label: {
                        Label("@kevinrpb", systemImage: "twitter")
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
                HStack {
                    Text("SwiftSoup (Nabil Chatbi)")
                    Spacer()
                    Button("MIT") {
                        openURL(.init(string: "https://github.com/scinfu/SwiftSoup")!)
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
