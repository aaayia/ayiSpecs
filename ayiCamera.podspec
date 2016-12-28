
Pod::Spec.new do |s|


  s.name         = "ayiCamera"
  s.version      = "1.0.0"
  s.summary      = "测试 测试 测试"

  
  s.description  = "试 测试 测试"

  s.homepage     = "https://github.com/twiightzzy/ayiSpecs"

  s.license      = { :type => 'MIT', :text => 'LICENSE' }
  s.author       = { "ayi" => "twilightzzy@126.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/twiightzzy/ayiSpecs.git", 
                     :tag => "#{s.version}" }

  s.source_files  = "ayiCamera/ayi/**/*.{h,m}"

 # s.source_files = 'ayiCamera/ayi/**/*'

  s.frameworks    = "UIKit"
  s.requires_arc  = true

end

