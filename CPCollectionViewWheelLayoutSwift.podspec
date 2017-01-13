Pod::Spec.new do |s|
  s.name             = 'CPCollectionViewWheelLayoutSwift'
  s.version          = '0.1.3'
  s.summary          = 'An awesome layout for UICollcetionView'
  s.description      = <<-DESC
  An awesome layout for UICollcetionView!
                       DESC
  s.homepage         = 'https://github.com/parsifalc/CPCollectionViewWheelLayoutSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Parsifal' => 'zmw@izmw.me' }
  s.source           = { :git => 'https://github.com/parsifalc/CPCollectionViewWheelLayoutSwift.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'CPCollectionViewWheelLayoutSwift/**/*.swift'
  s.frameworks = 'UIKit'
end
