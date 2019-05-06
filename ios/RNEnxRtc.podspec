
require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name         = "RNEnxRtc"
  s.version      = "1.0.0"
  s.summary      = "RNEnxRtc"
s.description  = "This is my lib."


  s.homepage     = "www.google.com"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNEnxRtc.git", :tag => "master" }
  s.source_files  = "RNEnxRtc/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "EnxRTCiOS"
  s.dependency 'Socket.IO-Client-Swift', '~> 12.0.0'


end

  



