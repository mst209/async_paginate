# frozen_string_literal: true

require_relative "async_paginate/version"
require 'async'
require 'async/barrier'
require 'async/semaphore'

module AsyncPaginate

  def async_paginate(concurrency, page_fetch_lambda)
    barrier = Async::Barrier.new
    semaphore = Async::Semaphore.new(concurrency, parent: barrier)
    page = 1

    first_page_result = page_fetch_lambda.call(page)
    total_pages = first_page_result[:page_count]
    page_results = [ first_page_result[:payloads] ]
    return page_results if total_pages <= 1
    Sync do
      (2..total_pages).each do |page|
        semaphore.async(parent: barrier) do
          page_fetch_lambda.call(page)
        end
      end
    end
    tasks = barrier.tasks.to_a.map(&:task)
    page_results.concat(wait_for_results(tasks))
    barrier.stop
    page_results.flatten
  end
  
  def wait_for_results(tasks)
    task_results = []
    tasks.each do |task|
      task.wait
      task_results << task.result[:payloads]
    end
    task_results
  end

end


