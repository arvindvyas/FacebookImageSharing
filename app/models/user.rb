class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, 
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable ,:lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :auth_token ,  :provider, :uid, :facebook_image, :dropbox_session
     
  has_many :images
    
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    
    user = User.where(:email => auth.info.email, :uid => auth.uid).first
    
    unless user
      
      user = User.create(name:auth.extra.raw_info.name,                         
        uid:auth.uid,
        email:auth.info.email,
        facebook_image:auth.info.image,
        auth_token: auth.credentials.token,
        name: auth.info.name,
        password: Devise.friendly_token[0,20]
      )
    else
        
      user.update_attributes( auth_token: auth.credentials.token , facebook_image: auth.info.image)
        
    end
      
    user
      
  end

 
  def admin?

    self.is_admin

  end
  
  def download_to_dropbox(user_id,image_id)
    current_user = User.find_by_id(user_id)
    dbsession = DropboxSession.deserialize(current_user.dropbox_session)
    client = DropboxClient.new(dbsession, DROPBOX_APP_MODE)     
    image = Image.find_by_id(image_id)    
    #filename= File.join(Rails.root,"public",Time.now.to_i.to_s+"."+image.picture_file_name.split(".").last)       
    #require 'open-uri'
    #open(filename, 'wb') do |file|
    #   file << open(image.picture.url).read
    #end        
    #data = File.read(filename)          
    client.get_file(image.picture.url)
    client.shares(image.picture.url)
  end
    
  
   
  
end
