class Bookmark < ActiveRecord::Base
  URI_SCHEMES = %w(http https)

  acts_as_taggable

  belongs_to :user

  validates_presence_of :url, :title, :user_id
  validates_format_of :url, :with => URI.regexp(URI_SCHEMES)

  cattr_accessor :per_page

  def self.per_page
    @@per_page ||= 50
  end

  def self.search(term)
    if term.blank?
      scoped
    else
      where("UPPER(title) LIKE :term OR UPPER(cached_tag_list) LIKE :term", 
            :term => "%#{term}%".upcase)
    end
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
      create!(bookmarks)
    end
  end

  def host
    URI.parse(url).host rescue nil
  end
end
