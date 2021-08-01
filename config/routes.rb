# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get '/search', to: 'search#index'

  resources :jobs, only: :show
end
