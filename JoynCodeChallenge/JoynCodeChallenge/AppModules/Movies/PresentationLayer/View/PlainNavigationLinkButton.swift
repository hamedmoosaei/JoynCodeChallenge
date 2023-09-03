//
//  PlainNavigationLinkButton.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/30/23.
//

import SwiftUI

struct PlainNavigationLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        PlainNavigationLinkButton(configuration: configuration)
    }
}

struct PlainNavigationLinkButton: View {
    @Environment(\.isFocused) var focused: Bool
    let configuration: ButtonStyle.Configuration
    
    var body: some View {
        configuration.label
            .scaleEffect(focused ? 1 : 0.9)
            .animation(.easeInOut(duration: 0.2), value: focused)
    }
}
