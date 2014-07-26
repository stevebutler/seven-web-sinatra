require "sinatra"
require "data_mapper"
require "dm-serializer"
require_relative "bookmark"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bookmarks.db")
DataMapper.finalize.auto_upgrade!

get "/bookmarks" do
  content_type :json
  get_all_bookmarks.to_json
end

def get_all_bookmarks
  Bookmark.all(:order => :title)
end

post "/bookmarks" do
  input = params.slice "url", "title"
  bookmark = Bookmark.create input
  [201, "/bookmarks/#{bookmark['id']}"]
end

class Hash
  def slice(*whitelist)
    whitelist.inject({}) {|result, key| result.merge(key => self[key])}
  end
end

get "bookmarks/:id" do
  id = params[:id]
  bookmark = Bookmark.get(id)
  content_type :json
  bookmark.to_json
end

put "bookmarks/:id" do
  id = params[:id]
  bookmark = Bookmark.get(id)
  input = params.slice "url", "title"
  bookmark.update input
  204 # No Content
end
