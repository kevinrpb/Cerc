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
        SettingsHeader("Customization", image: "paintpalette")
        CustomizationSection()
        Spacer(minLength: 30)
        SettingsHeader("Links", image: "link")
        LinksSection()
        Spacer(minLength: 30)
        SettingsHeader("Third Party Software", image: "doc.text")
        LicensesSection()
        Spacer(minLength: 30)
    }

    private func CustomizationSection() -> some View {
        CercListItem(tint: tintColor) {
            VStack {
                HStack {
                    Text("Tint Color")
                    Spacer()
                    NavigationLink(destination:
                        CercSelectionView(title: "Tint Color", selected: $settings.tintColorKey, elements: .constant(Color.keys), dismissOnSelect: false) { colorKey in
                            HStack {
                                Circle()
                                    .fill(Color.colorForKey[colorKey]!)
                                    .frame(width: 20, height: 20)
                                Text(colorKey.capitalized)
                            }
                        }
                        .environment(\.tintColor, tintColor)
                    ) {
                        HStack {
                            Circle()
                                .fill(tintColor)
                                .frame(width: 20, height: 20)
                            Text(settings.tintColorKey.capitalized)
                                .foregroundColor(.primary)
                        }
                        .cercBackground()
                    }
                }
                if UIApplication.shared.supportsAlternateIcons {
                    HStack {
                        Text("App Icon")
                        Spacer()
                        NavigationLink(destination:
                            CercSelectionView(title: "App Icon", selected: $settings.appIcon, elements: .constant(AppIcon.allCases), dismissOnSelect: false) { icon in
                                if let icon = icon {
                                    settings.setAppIcon(icon)
                                }
                            } labelProvider: { icon in
                                HStack {
                                    Image(uiImage: icon.image)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .mask(RoundedRectangle(cornerRadius: 8.8, style: .continuous))
                                    Text(icon.name.capitalized)
                                }
                            }
                            .environment(\.tintColor, tintColor)
                        ) {
                            HStack {
                                Image(uiImage: settings.appIcon.image)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .mask(RoundedRectangle(cornerRadius: 5.28, style: .continuous))
                                Text(settings.appIcon.name)
                                    .foregroundColor(.primary)
                            }
                            .cercBackground()
                        }
                    }
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

    private func SettingsHeader(_ title: LocalizedStringKey, image: String) -> some View {
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
