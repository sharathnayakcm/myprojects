require 'rho/rhocontroller'
require 'helpers/browser_helper'

class LocationController < Rho::RhoController
  include BrowserHelper

  # GET /Location
  def index
    @locations = Location.find(:all)
    render 
  end

  # GET /Location/{1}
  def show
    @location = Location.find(@params['id'])
    if @location
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Location/new
  def new
    @location = Location.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Location/{1}/edit
  def edit
    @location = Location.find(@params['id'])
    if @location
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Location/create
  def create
    @location = Location.create(@params['location'])
    redirect :action => :index
  end

  # POST /Location/{1}/update
  def update
    @location = Location.find(@params['id'])
    @location.update_attributes(@params['location']) if @location
    redirect :action => :index
  end

  # POST /Location/{1}/delete
  def delete
    @location = Location.find(@params['id'])
    @location.destroy if @location
    redirect :action => :index  
  end
end
