Pod::Spec.new do |s|

  s.name = "SwiftUICollectionView"
  s.version = "0.0.1"
  s.summary = "SwiftUI representable of UIKit CollectionView that supports compositional layout."

  s.swift_version = '5.6'
  s.platform = :ios
  s.ios.deployment_target = '16.0'

  s.description = <<-DESC
  SwiftUI CollectionView representable of UIKit UICollectionView 
  that supports UICollectionViewCompositionalLayout.
  DESC

  s.homepage = "https://github.com/michzio/SwifUICollectionView"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Michał Ziobro" => "swiftui.developer@gmail.com" }

  s.source = { :git => "https://github.com/michzio/SwifUICollectionView.git", :tag => "#{s.version}" }

  s.source_files = "SwiftUICollectionView/**/*.swift"
  s.public_header_files = "SwiftUICollectionView/**/*.h"

  s.framework = "UIKit"
  
end
