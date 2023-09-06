//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import FluentUI
import SwiftUI

struct SetupView: View {
    @ObservedObject var viewModel: SetupViewModel
    let viewManager: VideoViewManager
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Orientation var orientation: UIDeviceOrientation
    let avatarManager: AvatarViewManagerProtocol

    enum LayoutConstant {
        static let spacing: CGFloat = 24
        static let spacingLarge: CGFloat = 40
        static let startCallButtonHeight: CGFloat = 52
        static let iPadLarge: CGFloat = 469.0
        static let iPadSmall: CGFloat = 375.0
        static let iPadSmallHeightWithMargin: CGFloat = iPadSmall + spacingLarge + startCallButtonHeight
        static let iPadLargeHeightWithMargin: CGFloat = iPadLarge + spacingLarge + startCallButtonHeight
    }

    var body: some View {
        ZStack {
            VStack {
                SetupTitleView(viewModel: viewModel)
                GeometryReader { geometry in
                    ZStack(alignment: .bottomLeading) {
                        VStack(spacing: getSizeClass() == .ipadScreenSize ?
                            LayoutConstant.spacingLarge : LayoutConstant.spacing)
                        {
                            ZStack(alignment: .bottom) {
                                PreviewAreaView(viewModel: viewModel.previewAreaViewModel,
                                                viewManager: viewManager,
                                                avatarManager: avatarManager)
                                if viewModel.shouldShowSetupControlBarView() {
                                    SetupControlBarView(viewModel: viewModel.setupControlBarViewModel)
                                }
                            }
                            .background(Color(StyleProvider.color.backgroundColor))
                            .cornerRadius(6)
                            .padding(.bottom, 20)
                            .padding(.horizontal, setupViewHorizontalPadding(parentSize: geometry.size))
                            joinCallView
                        }
                        errorInfoView
                            .padding(.bottom, setupViewVerticalPadding(parentSize: geometry.size))
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            viewModel.setupAudioPermissions()
            viewModel.setupCall()
        }
    }

    var joinCallView: some View {
        VStack {
            Group {
                if viewModel.isJoinRequested {
                    JoiningCallActivityView(viewModel: viewModel.joiningCallActivityViewModel)
                } else {
                    PrimaryButton(viewModel: viewModel.joinCallButtonViewModel)
                        .accessibilityIdentifier(AccessibilityIdentifier.joinCallAccessibilityID.rawValue)
                        .padding()
                }
            }
        }.frame(height: 96)
            .background(Color(hex: 0x435363))
            .cornerRadius(30)
    }

    var errorInfoView: some View {
        VStack {
            Spacer()
            ErrorInfoView(viewModel: viewModel.errorInfoViewModel)
                .padding(EdgeInsets(top: 0,
                                    leading: 0,
                                    bottom: LayoutConstant.startCallButtonHeight + LayoutConstant.spacing,
                                    trailing: 0)
                )
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
        }
    }

    private func setupViewHorizontalPadding(parentSize: CGSize) -> CGFloat {
        let isIpad = getSizeClass() == .ipadScreenSize
        guard isIpad else {
            return 16
        }
        let isLandscape = orientation.isLandscape
        let screenSize = isLandscape ? LayoutConstant.iPadLarge : LayoutConstant.iPadSmall
        let horizontalPadding = (parentSize.width - screenSize) / 2.0
        return horizontalPadding
    }

    private func setupViewVerticalPadding(parentSize: CGSize) -> CGFloat {
        let isIpad = getSizeClass() == .ipadScreenSize
        guard isIpad else {
            return 16
        }
        let isLandscape = orientation.isLandscape
        let verticalPadding = (parentSize.height - (isLandscape ?
                LayoutConstant.iPadSmallHeightWithMargin
                : LayoutConstant.iPadLargeHeightWithMargin)) / 2.0
        return verticalPadding
    }

    private func getSizeClass() -> ScreenSizeClassType {
        switch (widthSizeClass, heightSizeClass) {
        case (.compact, .regular):
            return .iphonePortraitScreenSize
        case (.compact, .compact),
             (.regular, .compact):
            return .iphoneLandscapeScreenSize
        default:
            return .ipadScreenSize
        }
    }
}

struct SetupTitleView: View {
    let viewHeight: CGFloat = 48.0
    let padding: CGFloat = 40.0
    let verticalSpacing: CGFloat = 10
    var viewModel: SetupViewModel

    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                IconButton(viewModel: viewModel.dismissButtonViewModel)
                    .flipsForRightToLeftLayoutDirection(true)
                    .accessibilityIdentifier(AccessibilityIdentifier.dismissButtonAccessibilityID.rawValue)

                Text(viewModel.title)
                    .font(Fonts.footnote.font)
                    .foregroundColor(Color(StyleProvider.color.onBackground))
                    .lineLimit(1)
                    .minimumScaleFactor(sizeCategory.isAccessibilityCategory ? 0.4 : 1)
                    .accessibilityAddTraits(.isHeader)
                    .padding(.leading, padding)
                HStack {
                    VStack {
                        if let subtitle = viewModel.subTitle, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(Fonts.caption1.font)
                                .foregroundColor(Color(StyleProvider.color.onNavigationSecondary))
                                .lineLimit(1)
                                .minimumScaleFactor(sizeCategory.isAccessibilityCategory ? 0.4 : 1)
                                .accessibilityAddTraits(.isHeader)
                        }
                    }
                    Spacer()
                }.accessibilitySortPriority(1)
                    .padding(padding)
            }.frame(height: viewHeight)

                .background(Color(hex: 0x435363))
                .cornerRadius(6)
                .padding(10)
        }
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

struct TopRoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.minX + rect.width / 2, y: rect.minY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
