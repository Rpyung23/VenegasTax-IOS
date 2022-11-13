//
//  Camera.swift
//  Venegas Tax Service
//
//  Created by Vigitrack on 13/11/22.
//

import SwiftUI

private var addToPhotoStream: ((AVCapturePhoto) -> Void)?

private var addToPreviewStream: ((CIImage) -> Void)?

var isPreviewPaused = false

lazy var previewStream: AsyncStream<CIImage> = {
    AsyncStream { continuation in
        addToPreviewStream = { ciImage in
            if !self.isPreviewPaused {
                continuation.yield(ciImage)
            }
        }
    }
}()

lazy var photoStream: AsyncStream<AVCapturePhoto> = {
    AsyncStream { continuation in
        addToPhotoStream = { photo in
            continuation.yield(photo)
        }
    }
}()
