class Bookmark < ActiveRecord::Base
  URI_SCHEMES = %w(http https)

  acts_as_taggable

  belongs_to :user

  validates_presence_of :url, :title, :user_id
  validates_format_of :url, :with => URI.regexp(URI_SCHEMES)

  cattr_accessor :per_page

  scope :starred, where(:starred => true)

  define_index do
    indexes title
    indexes cached_tag_list
    has user_id
  end

  def self.per_page
    @@per_page ||= 50
  end

  def self.tag_counts(options = {})
    tag_counts_on(:tags, options) 
  end

  def self.import(data, user_id)
    bookmarks = []

    Nokogiri::HTML(data.read).css("a").each do |link|
      bookmarks << {
        :url      => link.attributes["href"],
        :title    => link.inner_html,
        :tag_list => link.attributes["tags"].to_s.split(" ").join(","),
        :user_id  => user_id
      }
    end

    if !bookmarks.empty?
      transaction { create!(bookmarks) }
    end
  end

  def host
    URI.parse(url).host rescue nil
  end

  def toggle_starred
    self.starred = !self.starred?
  end
end
