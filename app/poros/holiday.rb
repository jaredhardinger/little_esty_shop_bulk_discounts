class Holiday
      attr_reader :name, :date

  def initialize(data)
    @data = data
  	@name = data[:name]
  	@date = data[:date]
  end
end