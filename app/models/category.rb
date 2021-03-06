=begin

  @File Name                 : category.rb
  @Company Name              : Mindfire Solutions
  @Creator Name              : Hare Ram Rai
  @Date Created              : 10-01-2013
  @Date Modified             :
  @Last Modification Details :
  @Purpose                   : To manage the category  model

=end
class Category < ActiveRecord::Base
  
  # defining the attribute  accessible
  attr_accessible :title 
     
  ##########################
  #Defining Associations   #
  ##########################
  
  has_many :images   
  has_many :image_views, :through => :images
  has_many :image_downloads, :through => :images
  has_many :image_shares, :through => :images 
    
  ##########################
  #End Defining Associations
  ##########################
   
  
end
