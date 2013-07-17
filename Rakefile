# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

if ARGV.join(' ') =~ /spec/
    Bundler.require :default, :spec
else
    Bundler.require
end

Motion::Project::App.setup do |app|

    app.identifier = 'org.argosity.lb.sales'

    app.name = 'LB Sales'

    app.files = (app.files - Dir.glob('./app/**/*.rb')) +
        Dir.glob("./lib/**/*.rb") +
        Dir.glob("./config/**/*.rb") +
        ["./app/models/ledger_buddy_model.rb"] +
        Dir.glob("./app/**/*.rb")


    app.vendor_project('vendor/Reachability', :static)
    app.vendor_project('vendor/TVNavigationController', :static)
    app.vendor_project('vendor/iCarousel', :static)
    app.vendor_project('vendor/SVProgressHUD', :static,  cflags: '-fobjc-arc')

    app.detect_dependencies = false

    app.frameworks = %w{ MapKit ImageIO QuartzCore }

    app.pods do
        pod 'NSData+MD5Digest'
        pod 'ViewDeck'
        pod 'SDWebImage'
    end

end

# Track and specify files and their mutual dependencies within the :motion
# Bundler group
#MotionBundler.setup do |app|
#    app.require "hashie/mash"
#    app.require 'set'
#end


task :resources do
    icons = %w(success failure offline)
    icons += (0..5).to_a.collect { |i| "weather-#{i}" }

    icons.each do |icon|
        sh "convert -resize 88x88 app/assets/#{icon}.png resources/#{icon}@2x.png"
        sh "convert -resize 44x44 app/assets/#{icon}.png resources/#{icon}.png"
    end
end
