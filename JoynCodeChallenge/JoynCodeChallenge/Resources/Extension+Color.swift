//
//  Extension+Color.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/30/23.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...0.7),
                     green: .random(in: 0...0.7),
                     blue: .random(in: 0...0.7))
    }
}
