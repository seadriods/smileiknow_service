class UsersController < ApplicationController
  def upload_image
    img = params[:img]
    if img.nil?
      render :text => "INVALID", :layout => false
      return false
    end

    
    # Write the image to a file.
    img_name = "#{Time.now.to_i}.jpeg"
    File.open("public/images/collage/#{img_name}", "wb") do |file|
      file.write(img)
    end
    
    image = Image.new
    image.name = img_name
    image.user_id = params[:id]
    image.save   
    
    #also invalidate user's collage
    user = User.find(params[:id])
    user.collage = nil
    user.save
    
    render :text => 'SUCCESS', :layout => false 
  end

  def get_collage
    user = User.find_by_id(params[:id])
    base_url = "public/images/collage/"
    if !params[:m].nil? && params[:m] == "mobile"
      collage = 'smileout_25.png'
    else
      collage = 'smileout_50.png'
    end

    unless user.nil?
      
      if user.collage.blank?
        #create collage
        i = 0
        user.images.all(:order =>"id desc",:limit =>4).reverse.each do |img|
          `convert public/images/collage/#{img.name} -resize 200x200^ -gravity center -extent 200x200 public/images/collage/img#{i}.png`
          i = i+1
        end
        if i > 0
          collage = "#{user.id}_collage_#{Time.now.to_i}.png"
          `montage public/images/collage/img*.png -tile 4x1 -geometry +0+0 public/images/collage/row.png`
          `convert public/images/collage/row.png -alpha set -virtual-pixel transparent -channel A -blur 0x8 -level 50%,100% +channel public/images/collage/soft_row.png`
          `composite public/images/collage/soft_row.png public/images/collage/pane.png public/images/collage/frame.png`
          `composite -gravity SouthWest -geometry +42+0 public/images/collage/yellowsmile.gif public/images/collage/frame.png -alpha Set public/images/collage/#{collage}`
          `convert public/images/collage/#{collage} -resize 25% public/images/collage/mobile_#{collage}`              
          
          user.collage = collage
          user.save
        end       
      else
        collage = user.collage
      end
      
      if !params[:m].nil? && params[:m] == "mobile"
        collage = "mobile_#{collage}"
      end
    end
    #render :text => "#{base_url}#{collage}"
    send_file "#{base_url}#{collage}", :type => 'image/png', :disposition => 'inline'
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
