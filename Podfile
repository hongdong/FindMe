platform :ios ,'6.0'
pod 'MBProgressHUD'
pod 'AFNetworking'
pod 'CUSLayout'
pod 'THProgressView'
pod 'SDWebImage'
pod 'MWPhotoBrowser'
pod 'AMSmoothAlert'
pod 'BBBadgeBarButtonItem'
post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |configuration|
            target.build_settings(configuration.name)['ARCHS'] = '$(ARCHS_STANDARD_32_BIT)'
        end
    end
end