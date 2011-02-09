class PagesController < ApplicationController
  before_filter :require_no_user, :only => :index
end
