class PhotosController < ApplicationController

  get "/photos" do
    if logged_in?
      @user = current_user
      @photos = Photo.all
      erb :'/photos/photos'
    else
      redirect to '/users/login'
    end
  end

  get "/photos/new" do
    if logged_in?
      erb :'/photos/create_photo'
    else
      redirect to '/login'
    end
  end

  post "/photos" do
    if params[:content].empty?
      redirect '/photos/new'
    else
      @photo = Photo.create(:title => params[:title], :caption => params[:caption], :image_url => params[:image_url])
      @photo.user_id = current_user.id
      @photo.save
    end
  end

  get "/photos/:id" do
    if logged_in?
      @photo = Photo.find_by_id(params[:id])
      erb :'/photos/show_photos'
    else
      redirect '/login'
    end
  end

  get "/photos/:id/edit" do
    if logged_in?
      @photo = Photo.find_by_id(params[:id])
        erb :'/photos/edit_photo'
      else
      redirect '/users/login'
    end
  end

  patch "/photos/:id" do
    @photo = Photo.find_by_id(params[:id])
    if !params[:content].empty?
      @photo.content = params[:content]
      @photo.save
      erb :'/photos/show_photos'
    else
      redirect "/photos/#{@photo.id}/edit"
    end
  end

  delete "/photos/:id/delete" do
    @photo = Photo.find_by_id(params[:id])
    if logged_in? && @photo.user_id == current_user.id
      @photo.delete
      redirect '/photos'
    else
      redirect '/login'
    end
  end
end
