workspace 'improve'

platform :ios, '8.0'

use_frameworks!

def shared_pods
    pod 'AsyncDisplayKit'
    pod 'Moya'
    pod 'ReactiveCocoa'
    pod 'Moya/ReactiveCocoa'
    pod 'SwiftSpinner'
    pod 'SWXMLHash'
    pod 'YapDatabase'
    pod 'Swinject'
    pod 'AsyncDisplayKit'
end

target 'improve' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
