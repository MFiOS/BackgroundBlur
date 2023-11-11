//
//  ContentView.swift
//  BackgroundBlur
//
//  Created by Chang To on 2021-11-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .padding()
            VisualEffectBlur(blurStyle: .systemMaterial)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 300, height: 400)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
