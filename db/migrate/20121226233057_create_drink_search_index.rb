class CreateDrinkSearchIndex < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE drinks ENGINE = MyISAM'
    execute 'CREATE FULLTEXT INDEX fulltext_drinks ON drinks (name, recipe, created_by)'
  end

  def down
    execute 'ALTER TABLE drinks ENGINE = InnoDB'
    execute 'DROP INDEX fulltext_drinks ON drinks'
  end
end
