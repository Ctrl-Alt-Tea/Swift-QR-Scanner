//
//  ContentView.swift
//  QR Scanner
//
//  Initially created by Dylan Rose on 2024/04/10.
//


import SwiftUI
import AVFoundation


struct ContentView: View {
    @State private var scannedCode: String?
    @State private var isScanning = false
    var body: some View {
        
        
        NavigationStack {
            Text("Welcome")
                //.font(.title)
                //.frame(width: 150.0, height: 120.0)
                //.background(Color.cyan)
                .foregroundColor(.gray)
                .cornerRadius(15)
                .minimumScaleFactor(0.5)
                .font(.system(size: 40))
                .bold()
                .lineLimit(1)
            
            Spacer()
            
                ZStack {
                     Color.clear // Set background color to transparent
                     
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        //.padding(3)
                       // .frame(width: 250, height: 250) // Set frame size to center the image
                        .frame(maxWidth: .infinity)
                    

                 }
                
            Spacer()
            
            NavigationLink(destination: ScanView()) {
                Text("Press to scan")
                    .multilineTextAlignment(.center)
                    .frame(width: 180.0, height: 100.0)
                    .background(Color.black.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 25))
                    .bold()
                    .lineLimit(1)            }
            
            Spacer()
        

        }
    }
}

#Preview {
    ContentView()
}
