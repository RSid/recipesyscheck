require 'sinatra'
require 'pry'
require 'shotgun'

def db_connection
  begin
    connection = PG.connect(dbname:'sys_recipes')
    yield(connection)
  ensure
    connection.close
  end
end

def find_articles
  db_connection do |conn|
    conn.exec('SELECT * FROM sys_recipes').values
  end
end

###################
#CONTROLLER
###################

get '/recipes' do

  erb: index
end

get '/recipes/:id' do

  erb: recipe
end
