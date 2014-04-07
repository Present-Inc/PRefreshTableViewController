Pod::Spec.new do |s|
  s.name         = "PRefreshTableViewController"
  s.version      = "0.0.4"
  s.summary      = "A UIViewController that manages table view state and custom refresh header/footer views"
  s.description  = <<-DESC
                    PTableViewController
                    ===
                    A UIViewController that manages table view state, including initializing, empty, refreshing header, and loading footer state.
                    It provides a protocol that should be implemented by any views to be used for the refreshControl property.

                    This controller simplifies retreiving and paging through data from any API, by providing a suite of protocol methods
                    for making refresh and load more requests.
                   DESC
  s.homepage     = "http://www.present.tv"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "justinmakaila" => "justinmakaila@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "http://www.bitbucket.org/presenttv/PRefreshTableViewController.git", :tag => s.version.to_s }
  s.source_files = 'PRefreshTableViewController/Classes/*.{h,m}'
  s.resource     = 'PRefreshTableViewController/Classes/*.{gif,xib}'
  s.dependency 'UIImage+animatedGif'
  s.requires_arc = true
end
