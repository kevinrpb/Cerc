//
//  ActivityView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/08/2019.
//  Taken from https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

struct ActivityView: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    init(_ style: UIActivityIndicatorView.Style = .large, isAnimating: Binding<Bool>) {
        self.style = style
        self._isAnimating = isAnimating
    }

    func makeUIView(context: UIViewRepresentableContext<ActivityView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }

}

struct LoadingView<Content>: View where Content: View {

    @Binding var isLoading: Bool

    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.content()
                    .disabled(self.isLoading)
                    .blur(radius: self.isLoading ? 40 : 0)

                VStack {
                    ActivityView(isAnimating: .constant(true))
                }
                .frame(width: geometry.size.width / 2.5,
                       height: geometry.size.height / 7)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(15)
                .shadow(radius: 4)
                .opacity(self.isLoading ? 1 : 0)
            }
            .animation(.spring())
        }
    }

}
