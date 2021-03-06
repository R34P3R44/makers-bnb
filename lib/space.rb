require 'pg'
require_relative 'connection'
require_relative '../database_connection.rb'

class Space
  attr_reader :id, :name, :description, :user_id, :price

  def initialize(id:, name:, description:, user_id:, price:)
    @name = name
    @id = id
    @description = description
    @user_id = user_id
    @price = price
  end

  def self.all
    result = Connection.query("SELECT * FROM spaces;")
    result.map do |space|
      ## Map through each space from the table and make them all space objects:
      Space.new(id: space['id'],
        name: space['name'],
        description: space['description'],
        user_id: space['user_id'],
        price: space['price']
      )
    end
  end

  def self.create(name:, description:, user_id:, price:)
    ## RETURNING id, name so that we can use them in Space.new below...
    result = Connection.query("INSERT INTO spaces (name, description, user_id, price) VALUES('#{name}', '#{description}', '#{user_id}', '#{price}' ) RETURNING id, name, description, user_id, price;")
    ## Create a new space object using the information we just inserted:
    Space.new(id: result[0]['id'],
      name: result[0]['name'],
      description: result[0]['description'],
      user_id: result[0]['user_id'],
      price: result[0]['price']
    )
  end

  def self.find(id:)
    return nil unless id
    result = Connection.query("SELECT * FROM spaces WHERE id = #{id}")
    Space.new(id: result[0]['id'],
      name: result[0]['name'],
      description: result[0]['description'],
      user_id: result[0]['user_id'],
      price: result[0]['price']
    )
  end

  def user_name
    user = User.find(id: @user_id)
    return nil unless user
    user.display_name
  end

end
