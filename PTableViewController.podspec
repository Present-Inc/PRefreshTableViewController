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
  s.platform     = :ios
  s.source       = { :git => "http://www.bitbucket.org/presenttv/PTableViewController.git", :tag => "0.0.1" }
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.resource     = "Classes/*.gif"
  s.requires_arc = true
end
