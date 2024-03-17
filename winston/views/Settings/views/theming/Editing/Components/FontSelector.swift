//
//  FontSelector.swift
//  winston
//
//  Created by Igor Marcossi on 09/09/23.
//

import SwiftUI

struct FontSelector: View {
  @Binding var theme: ThemeText
  var defaultVal: ThemeText
  var showColor: Bool = true
  
  var body: some View {
    VStack {
      LabeledSlider(label: "Size", value: $theme.size, range: 6...32)
        .resetter($theme.size, defaultVal.size)
      
      Divider()
			HStack(spacing: 2) {
			Picker("Font", selection: $theme.font) {
									Text("System").tag("")
									ForEach(UIFont.familyNames.sorted(), id: \.self) { family in
										//ForEach(UIFont.fontNames(forFamilyName: family), id: \.self) { font in
																			Label(family, systemImage: "a.circle")
										//PickerRow(text: family)
															}//}
								}
				.resetter($theme.font, defaultVal.font)
				
			Text("This is a Test.")
				.font(.custom(theme.font, size: theme.size))
			.fontWeight(theme.weight.t)
				}
			.padding(.horizontal, 16)
			
			Divider()
      
      HStack(spacing: 2) {
        ForEach(CodableFontWeight.allCases, id: \.self) { weight in
          Text("aA")
            .fontSize(20, weight.t)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RR(8, .primary.opacity(theme.weight == weight ? 0.1 : 0)))
            .contentShape(Rectangle())
            .onTapGesture {
              withAnimation(.default.speed(2)) {
                theme.weight = weight
              }
            }
        }
      }
      .frame(height: 48)
      .padding(.horizontal, 16)
      .resetter($theme.weight, defaultVal.weight)
      
      if (showColor) {
        Divider()
        
        SchemesColorPicker(theme: $theme.color, defaultVal: defaultVal.color)
      }
    }
  }
}

struct PickerRow: View {
		let text: String
		var body: some View {
				Text(text)
						//.foregroundColor(.red)
						.font(.custom(text, size: 16))
						//.italic()
		}
}
