//
//  ScanView.swift
//  QR Scanner
//
//  Intially created by Dylan Rose on 2024/04/10.
//
import SwiftUI
import AVFoundation


struct QRCodeScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        init(parent: QRCodeScannerView) {
            self.parent = parent
        }
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                AudioServicesPlaySystemSound(SystemSoundID(1106))
                parent.didFindCode(stringValue)
            }
        }
    }
    var didFindCode: (String) -> Void
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            return viewController
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return viewController
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        session.startRunning()
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ScanView: View {
    @State private var scannedCode: String?
    @State private var isScanning = true
    var body: some View {


            
            if let scannedCode = scannedCode {
                Text("Decoded QR Code: \(scannedCode)")
                    .padding()
                if let url = URL(string: scannedCode), UIApplication.shared.canOpenURL(url) {
                    HStack {
                        Button("Open in Browser") {
                            UIApplication.shared.open(url)
                        }
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width: 110.0, height: 50.0)
                        .background(Color.red.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .minimumScaleFactor(0.5)
                        .font(.system(size: 20))
                        .bold()
                        .lineLimit(1)
                    }
                }
                HStack {
                    
                    Button("Copy Text") {
                        UIPasteboard.general.string = scannedCode
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 110.0, height: 50.0)
                    .background(Color.red.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 20))
                    .bold()
                    .lineLimit(1)
                    
                    Button("Scan Again?") {
                        self.isScanning = true
                        self.scannedCode = nil
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 110.0, height: 50.0)
                    .background(Color.red.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 25))
                    .bold()
                    .lineLimit(1)
                    
                    
                }
            } else {
                if isScanning {
                    QRCodeScannerView(didFindCode: { code in
                        self.scannedCode = code
                    })
                    .edgesIgnoringSafeArea(.all)
                   // GeometryReader { proxy in
                        VStack(alignment: .center) {
                            Image(systemName: "viewfinder")
                               // .renderingMode(.original)
                                .resizable(resizingMode: .tile)
                                //.aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.gray)
                                .frame(alignment: .center)
                              //  .scaledToFit()
                                //.padding([.leading, .bottom, .trailing], 10.0)
                            .frame(width: 250, height: 250) // Set frame size to center the image
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        }
                        //.frame(alignment: .center)
                    }
                    //.frame(width: 200.0, height: 200.0, alignment: .center)
                    
               // }
                
            

                
                    Text("Created by Dylan Rose")
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
        }
    

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}





#Preview {
    ScanView()
}
