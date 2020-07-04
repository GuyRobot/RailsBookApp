# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :books do
    member do
      put 'add', to: 'books#library'
      put 'remove', to: 'books#library'
    end
  end
  resources :library, only: [:index]
  resources :pricing, only: [:index]
  resources :subscriptions

  devise_for :users, controller: { registrations: 'registrations' }
  root to: 'book#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
