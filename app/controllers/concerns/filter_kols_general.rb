module FilterKolsGeneral
  extend ActiveSupport::Concern

  private

  def apply_filters(data, filter)
    data = data.filter_follow(filter) unless filter_follower_empty?(filter)
    data = data.filter_like(filter) unless filter_like_empty?(filter)
    data = data.filter_industry(filter) unless filter_industry_empty?(filter)
    data
  end

  def filter_follower_empty?(filter)
    filter.nil? || (filter[:follow][:min].to_i == filter[:follow][:max].to_i && filter[:follow][:max].to_i.zero?)
  end

  def filter_like_empty?(filter)
    filter.nil? || (filter[:like][:min].to_i == filter[:like][:max].to_i && filter[:like][:max].to_i.zero?)
  end

  def filter_industry_empty?(filter)
    filter[:industry].nil?
  end
end
