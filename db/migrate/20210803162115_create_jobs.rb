# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs, primary_key: :guid do |t|
      t.string :link
      t.string :title
      t.string :location
      t.string :author
      t.text :description
      t.datetime :published_at
      t.datetime :updated_at
    end
  end
end
