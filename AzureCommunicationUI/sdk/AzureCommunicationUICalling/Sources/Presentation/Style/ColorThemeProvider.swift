//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import Foundation
import UIKit

class ColorThemeProvider {
    let colorSchemeOverride: UIUserInterfaceStyle

    let primaryColor: UIColor
    let primaryColorTint10: UIColor
    let primaryColorTint20: UIColor
    let primaryColorTint30: UIColor

    // MARK: Text Label Colours

    let onHoldLabel: UIColor = Colors.textSecondary
    lazy var onWarning: UIColor = dynamicColor(light: Colors.Palette.warningShade30.color,
                                               dark: Colors.surfacePrimary)

    let onHoldBackground = UIColor.compositeColor(.onHoldBackground)
    lazy var onError: UIColor = dynamicColor(light: Colors.surfacePrimary,
                                             dark: Colors.surfaceSecondary)

    lazy var onPrimary: UIColor = dynamicColor(light: Colors.surfacePrimary,
                                               dark: Colors.surfaceSecondary)

    lazy var onSuccess: UIColor = dynamicColor(light: Colors.surfacePrimary,
                                               dark: Colors.surfaceSecondary)

    lazy var onSurface: UIColor = dynamicColor(light: Colors.Palette.gray950.color,
                                               dark: Colors.textDominant)

    lazy var onBackground: UIColor = dynamicColor(light: Colors.Palette.gray950.color,
                                                  dark: Colors.textDominant)

    lazy var onSurfaceColor: UIColor = dynamicColor(light: Colors.Palette.gray950.color,
                                                    dark: Colors.textDominant)

    lazy var onNavigationSecondary: UIColor = dynamicColor(light: Colors.textSecondary,
                                                           dark: Colors.textDominant)

    // MARK: - Button Icon Colours

    let hangup = UIColor.compositeColor(.hangup)
    let disableColor: UIColor = Colors.iconDisabled
    let drawerIconDark: UIColor = Colors.iconSecondary

    // MARK: - View Background Colours

    let error: UIColor = Colors.error
    let success: UIColor = Colors.Palette.successPrimary.color
    lazy var warning: UIColor = dynamicColor(light: Colors.Palette.warningTint40.color,
                                             dark: Colors.warning)

    let overlay = UIColor.compositeColor(.overlay)
    let gridLayoutBackground: UIColor = Colors.surfacePrimary
    let gradientColor = UIColor.black.withAlphaComponent(0.7)
    let surfaceDarkColor = UIColor.black.withAlphaComponent(0.6)
    let surfaceLightColor = UIColor.black.withAlphaComponent(0.3)
    lazy var backgroundColor: UIColor = .init(hex: 0x292929)

    lazy var drawerColor: UIColor = dynamicColor(light: Colors.surfacePrimary,
                                                 dark: Colors.Palette.gray900.color)

    lazy var popoverColor: UIColor = dynamicColor(light: Colors.surfacePrimary,
                                                  dark: Colors.surfaceQuaternary)

    lazy var surface: UIColor = .init(hex: 0x292929)
    lazy var surfaceLight: UIColor = .init(hex: 0x435363)

    init(themeOptions: ThemeOptions?) {
        self.colorSchemeOverride = themeOptions?.colorSchemeOverride ?? .unspecified

        self.primaryColor = themeOptions?.primaryColor ?? Colors.Palette.communicationBlue.color
        self.primaryColorTint10 = themeOptions?.primaryColorTint10 ?? Colors.Palette.communicationBlueTint10.color
        self.primaryColorTint20 = themeOptions?.primaryColorTint20 ?? Colors.Palette.communicationBlueTint20.color
        self.primaryColorTint30 = themeOptions?.primaryColorTint30 ?? Colors.Palette.communicationBlueTint30.color
    }

    private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

extension ColorThemeProvider: ColorProviding {
    func primaryColor(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryTint10Color(for window: UIWindow) -> UIColor? {
        return primaryColorTint10
    }

    func primaryTint20Color(for window: UIWindow) -> UIColor? {
        return primaryColorTint20
    }

    func primaryTint30Color(for window: UIWindow) -> UIColor? {
        return primaryColorTint30
    }

    func primaryTint40Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryShade10Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryShade20Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryShade30Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
