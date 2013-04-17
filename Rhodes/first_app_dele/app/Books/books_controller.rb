require 'rho/rhocontroller'
require 'helpers/browser_helper'

class BooksController < Rho::RhoController
  include BrowserHelper

  # GET /Books
  def index
    @bookses = Books.find(:all)
    render :back => '/app'
  end

  # GET /Books/{1}
  def show
    @books = Books.find(@params['id'])
    if @books
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end
  def search
    @books = Books.find(:all,:conditions=>{'name'=>@params['books']['keyword']})
    render :action => :search, :back => url_for(:action => :index)
  end

  # GET /Books/new
  def new
    @books = Books.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Books/{1}/edit
  def edit
    @books = Books.find(@params['id'])
    if @books
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Books/create
  def create
    @books = Books.create(@params['books'])
    redirect :action => :index
  end

  # POST /Books/{1}/update
  def update
    @books = Books.find(@params['id'])
    @books.update_attributes(@params['books']) if @books
    redirect :action => :index
  end

  # POST /Books/{1}/delete
  def delete
    @books = Books.find(@params['id'])
    @books.destroy if @books
    redirect :action => :index  
  end
end
