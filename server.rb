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
    conn.exec('SELECT * FROM recipes ORDER BY name').values
  end
end

def find_recipe_ingredients (id)
  db_connection do |conn|
    conn.exec_params('SELECT * FROM ingredients JOIN recipes ON ingredients.recipe_id=recipes.id WHERE ingredients.recipe_id=$1',[id]).values
  end
end

def recipe_instructions (id)
  db_connection do |conn|
    conn.exec('SELECT instructions FROM recipes WHERE id =$1',[id]).values
  end
end

def stepify_recipe_instructions (id)
  instructions=recipe_instructions(id)
  instructions.flatten[0].split(/[0-9]\s/)
end

###################
#CONTROLLER
###################

get '/recipes' do
  @recipes=find_recipes

   erb :index
end

get '/recipes/:id' do
  @id=params[:id]

  @recipes=find_recipes
  @recipe_ingredients=find_recipe_ingredients(@id)
  @instructions=stepify_recipe_instructions(@id)

  erb :recipe
end
