//
//  File.swift
//  
//
//  Created by GoEun Jeong on 2021/08/25.
//

import SwiftUI

#if os(iOS) || os(OSX)

@available(iOS 14, macOS 11, *)
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

#endif
