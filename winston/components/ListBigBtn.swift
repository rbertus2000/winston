//
//  ListBigBtn.swift
//  winston
//
//  Created by Igor Marcossi on 30/07/23.
//

import SwiftUI
import Shiny
import Defaults

/// A button with an icon, label, and optional shiny gradient, used in a list.
struct ListBigBtn: View {
  /// The router proxy environment object.
  @EnvironmentObject private var routerProxy: RouterProxy
  /// The binding for the selected subreddit.
  @Binding var selectedSub: FirstSelectable?
  /// The icon name.
  var icon: String
  /// The color of the icon.
  var iconColor: Color
  /// The label text.
  var label: String
  /// The destination subreddit.
  var destination: Subreddit?
  /// The shiny gradient applied to the button.
  var shiny: Gradient?
  /// The value associated with the button.
  var value: (any Hashable)?
  @State private var pressed = false
  
  @Environment(\.useTheme) private var theme
  @Environment(\.colorScheme) private var cs
  
  /// Initializes a `ListBigBtn`.
  ///
  /// - Parameters:
  ///   - selectedSub: The binding for the selected subreddit (default is `nil`).
  ///   - value: The value associated with the button.
  ///   - destination: The destination subreddit (default is `nil`).
  ///   - iconColor: The color of the icon.
  ///   - label: The label text.
  ///   - icon: The icon name.
  ///   - shiny: The shiny gradient applied to the button (default is `nil`).
  init(selectedSub: Binding<FirstSelectable?>? = nil, value: (any Hashable)? = nil, destination: Subreddit? = nil, icon: String, iconColor: Color, label: String, shiny: Gradient? = nil) {
    self._selectedSub = selectedSub ?? .constant(nil)
    self.value = value
    self.label = label
    self.iconColor = iconColor
    self.icon = icon
    self.shiny = shiny
    self.destination = destination
  }
  
  var body: some View {
    let isNotCircled = !icon.contains("circle")
    Button {
      if let destination {
        selectedSub = .sub(destination)
      } else if let value{
        routerProxy.router.path.append(value)
      }
    } label: {
      VStack(alignment: .leading, spacing: 8) {
        Image(systemName: icon)
          .symbolRenderingMode(.palette)
          .foregroundStyle(.white, iconColor)
          .fontSize(isNotCircled ? 20 : 32)
          .padding(isNotCircled ? 5 : 0)
        Text(label)
          .fontSize(17, .semibold)
      }
      .padding(.all, 10)
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundColor(.primary)
      .themedListRowBG(pressed: pressed, shiny: shiny)
      .mask(RoundedRectangle(cornerRadius: 10).foregroundColor(.black))
      .contentShape(RoundedRectangle(cornerRadius: 13))
      //    .onChange(of: reset) { _ in active = false }
    }
    .buttonStyle(ButtonPressingProviderStyle(pressed: $pressed))
  }
}

