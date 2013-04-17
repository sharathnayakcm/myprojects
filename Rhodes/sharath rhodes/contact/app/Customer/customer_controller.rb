require 'rho/rhocontroller'
require 'helpers/browser_helper'

class CustomerController < Rho::RhoController
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
  
  def my_current_location
    if !GeoLocation.known_position?
      GeoLocation.set_notification( url_for(:action => :my_geo_callback), "", 2)
      redirect :action => :wait
    else
     map_params = {
                :provider => 'Google',
                :settings => {:map_type => "standard",:region => [GeoLocation.latitude, GeoLocation.longitude, 1, 1],
                              :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                              :api_key => 'Google Maps API Key'},   
                
      }
      
    MapView.create map_params
    
    redirect :action => :index
    
  end
  
  end
  
  
  def map_all
    if !GeoLocation.known_position?
      GeoLocation.set_notification( url_for(:action => :geo_callback), "", 2)
      redirect :action => :wait
    else
      @customers = Customer.find(:all)
      annotations = []
      @customers.each do |customer|
        orglat = customer.lat
        100.times do 
          customer.lat = customer.lat.to_f + 0.01
          customer.lat = customer.lat.to_s
          annotations << {
            :latitude => customer.lat,
            :longitude => customer.long,
            :title => "#{customer.first} #{customer.last}",
            :subtitle => "",
            :url => "/app/Customer/{#{customer.object}}"
          }
        end
        customer.lat = orglat
        100.times do 
          customer.long = customer.long.to_f + 0.05
          customer.long = customer.long.to_s
          annotations << {
            :latitude => customer.lat,
            :longitude => customer.long,
            :title => "#{customer.first} #{customer.last}",
            :subtitle => "",
            :url => "/app/Customer/{#{customer.object}}"
          }
        end
      end
      map_params = {
                :settings => {:map_type => "standard",:region => [GeoLocation.latitude, GeoLocation.longitude, 1, 1],
                              :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false,
                              :api_key => 'Google Maps API Key'},   
                :annotations => annotations
      }
      
      MapView.create map_params
      
      redirect :action => :index
    end
  end

  def geo_callback
    WebView.navigate url_for(:action => :map_all) if @params['known_position'].to_i != 0 && @params['status'] == 'ok'
  end

  def my_geo_callback
    WebView.navigate url_for(:action => :my_current_location) if @params['known_position'].to_i != 0 && @params['status'] == 'ok'
  end


  #GET /Customer
  def index
    @customers = Customer.find(:all)
    render
  end

  # GET /Customer/{1}
  def show
    @customer = Customer.find(@params['id'])
    if @customer
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /Customer/new
  def new
    @customer = Customer.new
    render :action => :new
  end

  # GET /Customer/{1}/edit
  def edit
    @customer = Customer.find(@params['id'])
    if @customer
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /Customer/create
  def create
    @customer = Customer.new(@params['customer'])
    @customer.save
    redirect :action => :index
  end

  # POST /Customer/{1}/update
  def update
    @customer = Customer.find(@params['id'])
    @customer.update_attributes(@params['customer']) if @customer
    redirect :action => :index
  end

  # POST /Customer/{1}/delete
  def delete
    @customer = Customer.find(@params['id'])
    @customer.destroy if @customer
    redirect :action => :index
  end
end
