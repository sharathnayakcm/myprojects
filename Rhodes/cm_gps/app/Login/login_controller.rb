require 'rho/rhocontroller'
require 'helpers/browser_helper'

class LoginController < Rho::RhoController
  include BrowserHelper

  # GET /Login
  def index
    @logins = Login.find(:all)
    render :back => '/app'
  end

  # GET /Login/{1}
  def show
    @login = Login.find(@params['id'])
    if @login
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Login/new
  def new
    app_info "jjjjjjjjjjjjjjj" +params[:login].inspect
    @login = Login.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Login/{1}/edit
  def edit
    @login = Login.find(@params['id'])
    if @login
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Login/create
  def create
    @login = Login.create(@params['login'])
    redirect :action => :index
  end

  # POST /Login/{1}/update
  def update
    @login = Login.find(@params['id'])
    @login.update_attributes(@params['login']) if @login
    redirect :action => :index
  end

  # POST /Login/{1}/delete
  def delete
    @login = Login.find(@params['id'])
    @login.destroy if @login
    redirect :action => :index  
  end
end
