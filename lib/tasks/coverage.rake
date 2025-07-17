namespace :coverage do
  desc 'Run tests and generate code coverage report'
  task :report => :environment do
    # Set SimpleCov coverage directory
    ENV['COVERAGE'] = 'true'
    
    # Clear previous coverage data
    FileUtils.rm_rf('coverage')
    
    # Run RSpec tests
    Rake::Task['spec'].invoke
    
    puts "\nCoverage report generated at #{Rails.root.join('coverage', 'index.html')}"
    puts "Open the report in your browser to view detailed coverage information."
  end
  
  desc 'Open the coverage report in the default browser'
  task :open => :environment do
    coverage_path = Rails.root.join('coverage', 'index.html')
    
    if File.exist?(coverage_path)
      case RbConfig::CONFIG['host_os']
      when /mswin|mingw|cygwin/
        system "start #{coverage_path}"
      when /darwin/
        system "open #{coverage_path}"
      when /linux|bsd/
        system "xdg-open #{coverage_path}"
      else
        puts "Cannot open browser automatically on this platform."
        puts "Please open #{coverage_path} in your browser manually."
      end
    else
      puts "Coverage report not found. Run 'rake coverage:report' first."
    end
  end
  
  desc 'Generate coverage report and open it in the browser'
  task :all => [:report, :open]
end
