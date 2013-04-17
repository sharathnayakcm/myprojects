# To change this template, choose Tools | Templates
# and open the template in the editor.

class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json
  def login
    @status = 'error'
    @data = User.authenticate?(params['username'], params['password'])

    #respond_with(@user_data, :status => @status)
    respond_to do |format|
      format.json{ render :json => @data.to_json }
    end
  end

  def user_info
    @user_info = User.info(params['id'], request.env['HTTP_HOST'])
    respond_to do |format|
      format.json{ render :json => @user_info.to_json }
    end
  end

  def user_profile_pic
    @user_info = User.profile_pic(params['id'], request.env['HTTP_HOST'], params['size'])
    respond_to do |format|
      format.json{ render :json => @user_info.to_json }
    end
  end

  def update_user_info
    user_data =  JSON.parse(params[:user])
    #user_data = ActiveSupport::JSON.decode(params[:user])

    if User.find params['user_id']
      user_info = User.find params['user_id']
      user_info.update_attributes(user_data)
      data = {:status => 'ok', :user_info => user_info}
    else
      data = {:status => 'error'}
    end

    respond_to do |format|
      format.json{ render :json => data.to_json }
    end
  end

  def user_list
    @user= User.select("login","id","email")
    if @user
      data = {:status => 'ok', :user => @user}
    else
      data = {:status => 'error'}
    end
    respond_to do |format|
      format.json{ render :json => data.to_json }
    end
  end


  def user_follow
    @follower = User.select("login","id","email").find(params[:user_id])
    @following_user = User.find(params[:following_user])
    if @follower
      @follow = Follow.new
      @follow.user_id = @follower.id
      @follow.follow_id = @following_user.id
      @follow.save
      data = {:status => 'ok', :follower => @follower}
    else
      data = {:status => 'error'}
    end

    respond_to do |format|
      format.json{ render :json => data.to_json }
    end

  end
end
