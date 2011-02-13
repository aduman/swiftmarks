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

  def self.tag_counts(options = {})
    tag_counts_on(:tags, options) 
  end

  def self.import(data, user_id)
    bookmarks = []

    data.each do |line|
      if /<DT><A HREF="(.*)" ADD_DATE="(.*)" PRIVATE="(.*)" TAGS="(.*)">(.*)<\/A>$/.match(line)
        bookmarks << {
          :url => $1,
          :title => $5,
          :tag_list => $4,
          :user_id => user_id
        }
      end
    end

    if !bookmarks.empty?
      create!(bookmarks)
    end
  end

  def uri
    if url.to_s.match(URI.regexp(URI_SCHEMES))
      URI.parse(url)
    end
  end
end
