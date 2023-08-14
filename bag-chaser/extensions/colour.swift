//
//  colour.swift
//  bag-chaser
//
//  Created by Raphael Lim on 14/8/23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColourTheme()
}

struct ColourTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let text = Color("TextColor")
    let buttonText = Color("ButtonTextColor")
    let card = Color("CardColor")
}
