class CalculatorPriceJobService < ApplicationService
  attr_reader :jobs

  def initialize(jobs)
    @jobs = jobs
  end

  def call
    total = 0
    @jobs.each do |job|
      total += job.price
    end
    total
  end
end
