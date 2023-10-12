module StatisticalModule
  def get_months_in_year(year)
    months = []
    (1..12).each do |month|
      months << Date.new(year, month, 1)
    end
    months
  end

  def get_last_6_months
    today = Date.today
    months = []

    6.downto(0) do |i|
      month = today.month - i
      year = today.year
      if month <= 0
        month += 12
        year -= 1
      end
      months << Date.new(year, month, 1)
    end

    months
  end
end
