Pod::Spec.new do |s|
  s.name             = 'HDRatingStarView'
  s.version          = '1.0.1'
  s.summary          = '高可自定义，支持任意粒度的星星点击、滑动评分. '
  s.description      = <<-DESC
高可自定义，支持任意粒度的星星点击、滑动评分.
                        DESC

  s.homepage         = 'https://github.com/wangwanjie/HDRatingStarView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangwanjie' => 'wangwanjie1993@gmail.com' }
  s.source           = { :git => 'https://github.com/wangwanjie/HDRatingStarView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '6.0'
  s.source_files  = "HDRatingStarView", "HDRatingStarView/**/*.{h,m}"
  # s.resource_bundles = {
  #   'HDRatingStarView' => ['HDRatingStarView/Assets/*.xcassets']
  # }
  s.resource = ['HDRatingStarView/Assets/*.xcassets']
  s.public_header_files = 'Resources/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true
end
