class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user=User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to :controller=>'users'
    else
      render :action => 'new'
    end
  end

  def show
    @user= User.find(params[:id])
    @tweets = @user.tweet
    @followers = @user.follows.count
    @following = @user.my_following(@user)
 end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Tweet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def check_follower(user)

  end

end
