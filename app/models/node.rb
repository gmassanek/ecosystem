class Node < ActiveRecord::Base
  require 'twitter_helper'
  require 'rubyoverflow'
  include Rubyoverflow
  has_many :relationships1, :class_name => 'Relationship', :foreign_key => 'node1_id' 
  has_many :relationships2, :class_name => 'Relationship', :foreign_key => 'node2_id'
  has_many :links, :as => :linkable
  has_many :tutorials, :as => :item
  has_many :user_knowledge_ratings, :as => :knowledgeable

  has_one :created_by, :foreign_key => 'id', :class_name => "User"
  has_one :last_updated_by, :foreign_key => 'id', :class_name => "User"

  has_one :site_handle, :as => :item

  validates :title, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :homepage, :format => {:with => URI::regexp}, :allow_blank => true

  accepts_nested_attributes_for :links, :reject_if => lambda { |a| a[:url].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :site_handle
  
  has_friendly_id :title, :use_slug => true

  def to_s
    title
  end
  
  def relationships
    relationships1 | relationships2
  end
  
  def related_nodes
    relationships.each.collect do |r|
      if r.node1_id == self.id
        r.node2
      else
        r.node1
      end
    end
  end

  def getHandle(handle)
    site_handle[handle]
  end

  def handles
    return site_handle.handles unless site_handle.nil?
  end

  def self.all(*args)
    self.find(:all, :order => "title")  
  end

  def tweets
    return TwitterHelper.twitter_search_for(twitter_search_key, :html => true) unless twitter_search_key.blank?
    #return []
  end

  def stack_results
    unless stack_search_key.blank?
      search_results =  Questions.retrieve_by_tag(stack_search_key, :page_size => 5) 
      results = []
      search_results.questions[1..5].each do |q|
        thread = {:title => q.title, :answers_url => q.question_answers_url}
        results << thread
      end
      return results
      #return []
    end
  end
end
