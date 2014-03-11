Pod::Spec.new do |s|
  s.name         = "PTableViewController"
  s.version      = "0.0.1"
  s.summary      = "A UIViewController that manages table view state and custom refresh header/footer views"
  s.description  = <<-DESC
                    PTableViewController
                    ===
                    A UIViewController that manages table view state, including initializing, empty, refreshing header, and loading footer state.
                    It provides a protocol that should be implemented by any views to be used for the refreshControler or loadMoreControl property.
                    
                    This controller simplifies retreiving and paging through data from any API, handles pull to refresh, and pull to load more.
                   DESC
  s.homepage     = "http://www.bitbucket.org/presenttv/PTableViewController"
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author       = { "justinmakaila" => "justinmakaila@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "http://www.bitbucket.org/presenttv/PTableViewController.git", :commit => "5bd53372c9e57934ca25b1a4791679f058c382ef" }
  s.source_files = 'PTableViewController/Classes/*.{h,m}'
  s.resource     = "PTableViewController/Classes/loader-white.gif"
  s.dependency 'UIImage+animatedGif'
  s.requires_arc = true
end
