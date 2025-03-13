//
//  Copyright © 2017 Imou. All rights reserved.
//

import UIKit

public extension UIImage {
    
    // 设置圆角
    func lc_imageRadius(_ radius: CGFloat) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale;
        format.opaque = false;
        let renderer = UIGraphicsImageRenderer.init(size: rect.size, format: format)
        let image = renderer.image { rendererContext in
            let context = rendererContext.cgContext
            context.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
            context.clip()
            self.draw(in: rect)
        }
        
        return image
        
    }
	
	/// 二分法压缩图片
	func lc_compressImage(limitDataSize: Int) -> Data? {
		guard var resultData = UIImageJPEGRepresentation(self, 1) else {
			return nil
		}
		
		if resultData.count < limitDataSize {
			return resultData
		}
		
//		var max: CGFloat = 1
//		var min: CGFloat = 0
		
        var compression: Double = 1.0
        var maxCompression: Double = 1.0
        var minCompression: Double = 0.0
        for _ in 0..<6 {
            compression = (maxCompression + minCompression) / 2.0
            if let data = UIImage.compressImageData(resultData, compression: compression) {
                resultData = data
            } else {
                return nil
            }
            if resultData.count < Int(CGFloat(limitDataSize) * 0.9) {
                minCompression = compression
            } else if resultData.count > limitDataSize {
                maxCompression = compression
            } else {
                break
            }
        }
        
        if resultData.count <= limitDataSize {
            return resultData
        }
        
        var longSideWidth = max(resultData.imageSize.height, resultData.imageSize.width)
        // 图片尺寸按比率缩小，比率按字节比例逼近
        while resultData.count > limitDataSize {
            let ratio = sqrt(CGFloat(limitDataSize) / CGFloat(resultData.count))
            longSideWidth *= ratio
            if let data = UIImage.compressImageData(resultData, limitLongWidth: longSideWidth) {
                resultData = data
            } else {
                return nil
            }
        }
		
		return resultData
	}
    
    /// 同步压缩图片到指定压缩系数，仅支持 JPG
    ///
    /// - Parameters:
    ///   - rawData: 原始图片数据
    ///   - compression: 压缩系数
    /// - Returns: 处理后数据
    static func compressImageData(_ rawData: Data, compression: Double) -> Data? {
        guard let imageSource = CGImageSourceCreateWithData(rawData as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let writeData = CFDataCreateMutable(nil, 0),
            let imageType = CGImageSourceGetType(imageSource),
            let imageDestination = CGImageDestinationCreateWithData(writeData, imageType, 1, nil) else {
                return nil
        }
        
        let frameProperties = [kCGImageDestinationLossyCompressionQuality: compression] as CFDictionary
        CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, frameProperties)
        guard CGImageDestinationFinalize(imageDestination) else {
            return nil
        }
        return writeData as Data
    }
    
    /// 同步压缩图片数据长边到指定数值
    ///
    /// - Parameters:
    ///   - rawData: 原始图片数据
    ///   - limitLongWidth: 长边限制
    /// - Returns: 处理后数据
	static func compressImageData(_ rawData: Data, limitLongWidth: CGFloat) -> Data? {
        guard max(rawData.imageSize.height, rawData.imageSize.width) > limitLongWidth else {
            return rawData
        }
        
        guard let imageSource = CGImageSourceCreateWithData(rawData as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let writeData = CFDataCreateMutable(nil, 0),
            let imageType = CGImageSourceGetType(imageSource) else {
                return nil
        }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        
        guard let imageDestination = CGImageDestinationCreateWithData(writeData, imageType, frameCount, nil) else {
            return nil
        }
        
        // 设置缩略图参数，kCGImageSourceThumbnailMaxPixelSize 为生成缩略图的大小。当设置为 800，如果图片本身大于 800*600，则生成后图片大小为 800*600，如果源图片为 700*500，则生成图片为 800*500
        let options = [kCGImageSourceThumbnailMaxPixelSize: limitLongWidth, kCGImageSourceCreateThumbnailWithTransform: true, kCGImageSourceCreateThumbnailFromImageIfAbsent: true] as CFDictionary
        
        if frameCount > 1 {
            // 计算帧的间隔
            let frameDurations = imageSource.frameDurations
            
            // 每一帧都进行缩放
            let resizedImageFrames = (0..<frameCount).compactMap { CGImageSourceCreateThumbnailAtIndex(imageSource, $0, options) }
            
            // 每一帧都进行重新编码
            zip(resizedImageFrames, frameDurations).forEach {
                // 设置帧间隔
                let frameProperties = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: $1, kCGImagePropertyGIFUnclampedDelayTime: $1]]
                CGImageDestinationAddImage(imageDestination, $0, frameProperties as CFDictionary)
            }
        } else {
            guard let resizedImageFrame = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {
                return nil
            }
            CGImageDestinationAddImage(imageDestination, resizedImageFrame, nil)
        }
        
        guard CGImageDestinationFinalize(imageDestination) else {
            return nil
        }
        
        return writeData as Data
    }
    
    func rebuildImageSize(rect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0;
        format.opaque = false;
        let renderer = UIGraphicsImageRenderer.init(size: rect.size, format: format)
        let newImage = renderer.image { rendererContext in
            self.draw(in: rect)
        }
        
        return newImage
    }
    
    func squareImageFromImage(scaledToSize: CGSize) -> UIImage {
        var scaleTransform: CGAffineTransform = CGAffineTransform()
        var originPoint: CGPoint = CGPoint.zero
        
        if self.size.width > self.size.height {
            let scaleRatio = scaledToSize.height / self.size.height
            scaleTransform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            originPoint = CGPoint(x: -(self.size.width - self.size.height) / 2.0, y: 0)
        } else {
            let scaleRatio = scaledToSize.width / self.size.width
            scaleTransform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            originPoint = CGPoint(x: 0, y: -(self.size.height - self.size.width) / 2.0)
        }
        var renderer: UIGraphicsImageRenderer!
        if UIScreen.main.responds(to: #selector(getter: scale)) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = 0.0;
            format.opaque = false;
            renderer = UIGraphicsImageRenderer.init(size: scaledToSize, format: format)
        } else {
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1.0;
            format.opaque = false;
            renderer = UIGraphicsImageRenderer.init(size: scaledToSize, format: format)
        }
        
        let image = renderer.image { rendererContext in
            let context = rendererContext.cgContext
            context.concatenate(scaleTransform)
            self.draw(at: originPoint)
        }
        return image
    }
}

extension Data {
    var imageSize: CGSize {
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any],
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat,
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat else {
                return .zero
        }
        return CGSize(width: imageWidth, height: imageHeight)
    }
}

extension CGImageSource {
    func frameDurationAtIndex(_ index: Int) -> Double {
        var frameDuration = Double(0.1)
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) as? [AnyHashable: Any], let gifProperties = frameProperties[kCGImagePropertyGIFDictionary] as? [AnyHashable: Any] else {
            return frameDuration
        }
        
        if let unclampedDuration = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber {
            frameDuration = unclampedDuration.doubleValue
        } else {
            if let clampedDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? NSNumber {
                frameDuration = clampedDuration.doubleValue
            }
        }
        
        if frameDuration < 0.011 {
            frameDuration = 0.1
        }
        
        return frameDuration
    }
    
    var frameDurations: [Double] {
        let frameCount = CGImageSourceGetCount(self)
        return (0..<frameCount).map { self.frameDurationAtIndex($0) }
    }
}
