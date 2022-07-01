# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#home'
  get '/login', to: 'sessions#new'
  post '/login/create', to: 'sessions#create'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
end
