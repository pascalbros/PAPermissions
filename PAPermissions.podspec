Pod::Spec.new do |s|
  s.name             = "PAPermissions"
  s.version          = "0.9.7"
  s.summary          = "A unified API to ask for permissions on iOS."
  s.homepage         = "https://github.com/pascalbros/PAPermissions"
  s.license          = 'MIT'
  s.author             = { "Pasquale Ambrosini" => "pasquale.ambrosini@gmail.com" }
  s.source       = { :git => "https://github.com/pascalbros/PAPermissions.git", :tag => "#{s.version}" }
  s.social_media_url = 'https://twitter.com/PascalAmbro'
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'PAPermissions/Classes/**/*.{swift}'
  s.resources = "PAPermissions/Assets/**/*"
  s.ios.framework = ['AVFoundation', 'CoreLocation', 'CoreBluetooth', 'CoreMotion', 'Photos']
end
