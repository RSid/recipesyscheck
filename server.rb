require 'sinatra'
require 'pry'
require 'shotgun'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname:'sys_recipes')
    yield(connection)
  ensure
    connection.close
  end
end

def find_recipes
  db_connection do |conn|
    conn.exec('SELECT * FROM recipes').values
  end
end

###################
#CONTROLLER
###################

get '/recipes' do
  @recipes=find_recipes

   erb :index
end

get '/recipes/:id' do

  erb :recipe
end
