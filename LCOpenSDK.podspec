
Pod::Spec.new do |spec|

  spec.name         = "LCOpenSDK"
  spec.version      = "3.10.0"
  spec.summary      = "乐橙云开放平台SDK"
  spec.description  = "乐橙云开放平台SDK,开发者可以用SDK开发APP"
  spec.homepage     = "https://github.com/LCOpenSDK/LCOpenSDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" } 
  spec.author       = { "Hanyanrui" => "OpenImoulife@163.com" }
  spec.platform     = :ios, "8.0"  
  spec.source       = { :git => "https://github.com/LCOpenSDK/LCOpenSDK.git", :tag => spec.version.to_s }
  spec.frameworks   = 'CoreLocation', 'CoreAudio', 'CoreVideo', 'CoreMedia', 'CFNetwork', 'VideoToolbox', 'AudioToolbox', 'AVFoundation','OpenGLES','MediaAccessibility','MediaPlayer'
  spec.libraries    = "z"
  spec.vendored_frameworks = 'Framework/LCOpenSDKDynamic.framework'

end
