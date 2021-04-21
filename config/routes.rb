Rails.application.routes.draw do
  
  devise_for :users
  
  root 'home#index'
  get 'home/index'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'
    
  resources :enrollments do
    get :my_students, on: :collection
  end  
  
  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end  
    resources :enrollments, only: [:new, :create]
    resources :lessons
  end    
  resources :users, only: [:index, :edit, :show, :update]
 
  namespace :charts do
    get 'course_popularity'
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'money_makers'
  end
  #get 'charts/users_per_day', to: 'charts#users_per_day'
  #get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  #get 'charts/course_popularity', to: 'charts#course_popularity'
  #get 'charts/money_makers', to: 'charts#money_makers'
end