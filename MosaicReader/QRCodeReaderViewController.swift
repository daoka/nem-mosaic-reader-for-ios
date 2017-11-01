//
//  QRCodeReaderViewController.swift
//  MosaicReader
//
//  Created by Kazuya Okada on 2017/10/31.
//  Copyright © 2017年 appirits. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer?
    var address: String?
    
    @IBOutlet weak var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAVFoundation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func prepareAVFoundation() {
        let videoDevice = AVCaptureDevice.default(for: .video)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice!)
        captureSession.addInput(videoInput)
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer!.frame = previewView.bounds
        videoLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewView.layer.addSublayer(videoLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func parseQRCode(qrStr:String) {
        let decoder = JSONDecoder()
        let qrInfo = try? decoder.decode(NemQRInfo.self, from: qrStr.data(using: .utf8)!)
        if qrInfo != nil && qrInfo!.data != nil && qrInfo!.data!.addr != nil {
            address = qrInfo!.data!.addr!
            self.captureSession.stopRunning()
            
            let ctr = self.presentingViewController as? UINavigationController
            let c = ctr?.topViewController as? MosaicListTableViewController
            c?.loadUserMosaics(address: address!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadada in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadada.type == AVMetadataObject.ObjectType.qr {
                if metadada.stringValue != nil {
                    parseQRCode(qrStr: metadada.stringValue!)
                }
            }
        }
    }
}

struct NemQRInfo: Codable {
    var data: NemQRData?
}

struct NemQRData: Codable {
    var addr: String?
}
