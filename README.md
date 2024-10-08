# AsyncPaginate

The `AsyncPaginate` module provides a mechanism to fetch multiple pages of data asynchronously in Ruby using the `async` gem. This is useful when you need to retrieve a large amount of paginated data in parallel to improve performance by controlling the number of concurrent requests.


## Key Features
- Asynchronous pagination with concurrency control.
- Fetches data in pages and combines the results.
- Uses `Async::Semaphore` to limit the number of concurrent tasks.
- Handles paginated API calls efficiently.

## Installation

To use the `AsyncPaginate` module, add the following line to your Gemfile and run `bundle install`:

```ruby
gem 'async_paginate'
```

## Usage

To use `async_paginate`, include the `AsyncPaginate` module in your class or script, and pass in the concurrency level and a lambda to fetch pages.

### Example

```ruby
require 'async'
require_relative 'async_paginate'

class Paginator
  include AsyncPaginate

  def fetch_data
    page_fetch_lambda = ->(page) { api_fetch_page(page) }

    # Use the async_paginate method with a concurrency of 5
    results = async_paginate(5, page_fetch_lambda)

    results.each do |data|
      puts data
    end
  end

  private

  def api_fetch_page(page)
    # Simulate an API call that returns paginated data
    {
      page_count: 10,
      payloads: ["Data from page #{page}"]
    }
  end
end

paginator = Paginator.new
paginator.fetch_data
```

In this example:
- `async_paginate` is called with a concurrency level of 5, meaning up to 5 pages can be fetched simultaneously.
- The lambda `page_fetch_lambda` is responsible for making the actual API call to fetch the page's data.
- `async_paginate` will handle fetching all pages in parallel and return the combined results.

### Arguments
- `concurrency`: An integer defining the maximum number of concurrent page fetch operations.
- `page_fetch_lambda`: A lambda function that accepts a page number and returns a hash containing:
  - `:page_count` (the total number of pages),
  - `:payloads` (the data from that specific page).

### Returned Value
- An array containing all the payload data across all pages.

## Benchmarks

You can test the performance of the `AsyncPaginate` module using the provided `PaginatorBenchmark` class. The example below demonstrates how to run benchmarks by varying the number of pages and concurrency levels, then measuring the time taken to complete the task.

### Benchmark Example

```ruby
class PaginatorBenchmark
  include AsyncPaginate
  
  def async_test(pages = 5, concurrency = 1)
    puts "[Test] Fetching #{pages} pages with a concurrency of #{concurrency}"
    t = Time.now
    page_fetch_lambda = fetch_page(pages)
    async_paginate(concurrency, page_fetch_lambda)
    puts "Fetched #{pages} pages with concurrency #{concurrency}, took #{Time.now - t} seconds"
  end

  private

  def fetch_page(pages)
    ->(page) {
      # Response time simulated from 0-3 seconds.
      s = Random.rand(3) + (Random.rand(10).to_f / 10)
      sleep(s)
      if page == 1
        puts "Fetched initial page, took #{s}s, now fetching pages 2-#{pages} asynchronously"
      else
        puts "Fetched page #{page}, took #{s}s"
      end
      {
        payloads: [
          "page: #{page}, record: #{((page - 1) * 3) + 1}",
          "page: #{page}, record: #{((page - 1) * 3) + 2}",
          "page: #{page}, record: #{((page - 1) * 3) + 3}",
        ],
        page_count: pages
      }
    }
  end
end

# Run benchmark tests
test_paginator = PaginatorBenchmark.new
test_paginator.async_test(5, 1)  # Fetching with concurrency of 1
test_paginator.async_test(5, 3)  # Fetching with concurrency of 3
test_paginator.async_test(5, 5)  # Fetching with concurrency of 5
```

### Sample Output

```
[Test] Fetching 10 pages with a concurrency of 1
Fetched initial page, took 1.6s, now fetching pages 2-10 asynchronously
Fetched page 2, took 2.5s
Fetched page 3, took 1.1s
Fetched page 4, took 0.9s
Fetched page 5, took 0.6s
Fetched page 6, took 0.4s
Fetched page 7, took 2.3s
Fetched page 8, took 0.8s
Fetched page 9, took 0.5s
Fetched page 10, took 1.3s
Fetched 10 pages with concurrency 1, took 12.018524 seconds

[Test] Fetching 10 pages with a concurrency of 3
Fetched initial page, took 1.0s, now fetching pages 2-10 asynchronously
Fetched page 3, took 1.0s
Fetched page 4, took 1.6s
Fetched page 2, took 2.4s
Fetched page 5, took 1.4s
Fetched page 7, took 1.5s
Fetched page 8, took 1.6s
Fetched page 6, took 2.9s
Fetched page 10, took 1.8s
Fetched page 9, took 2.3s
Fetched 10 pages with concurrency 3, took 7.206423 seconds

[Test] Fetching 10 pages with a concurrency of 10
Fetched initial page, took 0.9s, now fetching pages 2-10 asynchronously
Fetched page 5, took 0.0s
Fetched page 7, took 0.1s
Fetched page 9, took 0.2s
Fetched page 8, took 0.7s
Fetched page 3, took 1.1s
Fetched page 10, took 1.9s
Fetched page 6, took 2.0s
Fetched page 4, took 2.4s
Fetched page 2, took 2.6s
Fetched 10 pages with concurrency 10, took 3.505095 seconds
```

### Benchmark Analysis

- **Concurrency of 1**: Fetching pages sequentially (one at a time) results in a longer total execution time (12.02 seconds).
- **Concurrency of 3**: By increasing concurrency, some of the pages are fetched in parallel, reducing the total time to 7.2 seconds.
- **Concurrency of 10**: Fetching all pages concurrently maximizes performance, completing the task in just 3.5 seconds.

The `async_paginate` method allows you to scale the number of concurrent requests, providing a significant performance boost when fetching large amounts of paginated data.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/async_paginate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/async_paginate/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AsyncPaginate project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/async_paginate/blob/main/CODE_OF_CONDUCT.md).
