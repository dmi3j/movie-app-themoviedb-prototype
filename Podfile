platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'

pod 'AFNetworking', '2.5.0'
pod 'SDWebImage', '3.7.1'
pod 'AXRatingView', '1.0.3'

post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
        end
    end
end
