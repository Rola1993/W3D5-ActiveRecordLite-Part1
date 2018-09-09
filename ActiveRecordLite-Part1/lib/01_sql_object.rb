require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  attr_accessor :table_name, :attributes, :columns

#Remember that DB queries are expensive, so we only want to make the query once,
#regardless of how often ::columns gets called.
  def self.columns
    return @columns if @columns
    data = DBConnection.execute2(<<-SQL)
      select
        *
      from
        #{self.table_name}
    SQL
    @columns = data[0].map(&:to_sym)
    @columns
  end

  def self.finalize!
    self.columns.each do |col|
      define_method("#{col}=") do |val|
        self.attributes[col] = val
      end

      define_method("#{col}")  do
        self.attributes[col]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    # DBConnection.execute2(<<-SQL)
    #   select * from self.table_name;
    #
    # SQL
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send('#{attr_name}=', value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
    @attributes
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
