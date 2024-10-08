# frozen_string_literal: true

require_relative "lib/async_paginate/version"

Gem::Specification.new do |spec|
  spec.name = "async_paginate"
  spec.version = AsyncPaginate::VERSION
  spec.authors = ["mac tichner"]
  spec.email = ["mst209@gmail.com"]

  spec.summary = "Async Pagination Helper"
  spec.description = "The `AsyncPaginate` module provides a mechanism to fetch multiple pages of data asynchronously in Ruby using the `async` gem. This is useful when you need to retrieve a large amount of paginated data in parallel to improve performance by controlling the number of concurrent requests."
  spec.homepage = ""
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"


  spec.metadata["source_code_uri"] = "https://github.com/mst209/async_paginate"
  spec.metadata["changelog_uri"] = "https://github.com/mst209/async_paginate/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = ['lib/async_paginate.rb','lib/async_paginate/version.rb']
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem

  spec.add_runtime_dependency "async", "~> 1.30"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
