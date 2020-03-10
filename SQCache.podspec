Pod::Spec.new do |s|
  s.name         = 'SQCache'
  s.summary      = 'A lightweight, pure-Swift library for cache framework in iOS.'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'aloow' => '897034809@qq.com' }
  s.social_media_url = 'https://aloow.github.io/'
  s.homepage     = 'https://github.com/aloow/SQCache.git'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aloow/SQCache.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'SQCache/*.{swift}'
  
  # s.libraries = 'sqlite3'
  s.frameworks = 'UIKit', 'Foundation'
  s.module_name = 'SQCache'              #模块名称
end