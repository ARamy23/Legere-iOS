# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
workspace 'Legere-iOS'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

def core_pods
  pod 'SwifterSwift', '~> 4.6.0'
  pod 'Moya/RxSwift', '~> 12.0.1'
  pod 'RxSwift', '~> 4.5.0'
  pod 'RxCocoa', '~> 4.5.0'
  pod 'PromisesSwift', '~> 1.2.7'
  pod 'SwiftMessages', '~> 6.0.2'
  pod 'SwiftEntryKit', '~> 1.0.1'
end
def import_pods
  core_pods
  pod 'Hero', '~> 1.4.0'
  pod 'AlamofireNetworkActivityLogger', '~> 2.3.0'
  pod 'UPCarouselFlowLayout', '~> 1.1.2'
  pod 'Highlightr'
  pod 'SnapKit'
end

target 'Legere-iOS' do
  import_pods
end

target 'Core' do
  project 'Core/Core.project'
  core_pods
end

target 'Legere-iOSTests' do
  inherit! :search_paths
  import_pods
end
