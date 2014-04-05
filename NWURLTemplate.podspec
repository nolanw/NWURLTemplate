Pod::Spec.new do |spec|
  spec.name         = 'NWURLTemplate'
  spec.version      = '0.1'
  spec.summary      = 'URI Templates for iOS and OS X'
  spec.homepage     = 'https://github.com/nolanw/NWURLTemplate'
  spec.license      = { :type => 'Public domain' }
  spec.authors      = { 'Nolan Waite' => 'nolan@nolanw.ca' }
  spec.source       = { :git => 'https://github.com/nolanw/NWURLTemplate.git', :tag => 'v0.1' }
  spec.source_files = 'NWURLTemplate.{h,m}'
  spec.requires_arc = true
end
