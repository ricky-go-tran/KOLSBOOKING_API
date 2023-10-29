module ConstantHelper
  extend ActiveSupport::Concern

  JOBS_ACCEPTED_PARAMS = %w[post booking apply complete payment finish cancle].freeze
  REPORTS_ACCEPTED_PARAMS = %w[pending proccessing resovled rejected].freeze
end
