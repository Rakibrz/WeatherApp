//
//  Color+Extensions.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import SwiftUI

extension Color {

    static let theme = AppColors()

    /// Custom init with HEX code
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}


extension Color {
    
    /// Custom Colours provided in assets
    struct AppColors {
        let pink = Color("Pink")
        let pinkLight = Color("PinkLight")
        let pinkDark = Color("PinkDark")
        let indigo = Color("Indigo")
        let indigoDark = Color("IndigoDark")
        
        let linearIndigoDark = [Color.init(hex: 0x2E335A), Color.init(hex: 0x1C1B33)]
        let linearIndigo = [Color.init(hex: 0x5936B4), Color.init(hex: 0x362A84)]
    }
}
