//
//  ShapeModifier.swift
//  GECalendarDemo (iOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

public struct ShapeModifier: ViewModifier {
    let shape: ShapeType?
      
    public func body(content: Content) -> some View {
        switch shape {
        case .circle:
            content.clipShape(Circle())
        case .roundedRectangle(let cornerRadius):
            content.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .rectangle:
            content.clipShape(Rectangle())
        case .none:
            content
        }
        
    }
      
}
