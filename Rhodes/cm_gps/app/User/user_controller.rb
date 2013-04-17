require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserController < Rho::RhoController
  include BrowserHelper

  def map_it
    @customer = Customer.find(@params["id"])
    map_params = {
              :provider => 'Google',
              :settings => {:map_type => "standard",:region => [@customer.lat, @customer.long, 0.2, 0.2],
                            :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                            :api_key => 'Google Maps API Key'},
              :annotations => [{
                                  :latitude => @customer.lat,
                                  :longitude => @customer.long,
                                  :title => "#{@customer.first} #{@customer.last}",
                                  :subtitle => "Go to customer",
                                  :url => "/app/Customer/{#{@customer.object}}"
                              }]
         }

    MapView.create map_params

    redirect :action => :index
  end

  # GET /User
  def index
    @users = User.find(:all)
    render :back => '/app'
  end

  # GET /User/{1}
  def show
    @user = User.find(@params['id'])
    if @user
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /User/new
  def new
    @user = User.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /User/{1}/edit
  def edit
    @user = User.find(@params['id'])
    if @user
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /User/create
  def create
    @user = User.create(@params['user'])
    redirect :action => :index
  end

  # POST /User/{1}/update
  def update
    @user = User.find(@params['id'])
    @user.update_attributes(@params['user']) if @user
    redirect :action => :index
  end

  # POST /User/{1}/delete
  def delete
    @user = User.find(@params['id'])
    @user.destroy if @user
    redirect :action => :index  
  end
end
