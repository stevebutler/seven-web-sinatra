require_relative "app"
require "rspec"
require "rack/test"

describe "Bookmark application" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "creates a new bookmark" do
    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    last_size = bookmarks.size
    
    post "/bookmarks", {:url => "http://www.test.int", :title => "Test"}

    expect(last_response.status).to eq(201)
    expect(last_response.body).to match(/\/bookmarks\/\d+/)

    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    expect(bookmarks.size).to eq(last_size + 1)
  end

  it "updates a bookmark" do
    post "/bookmarks", {:url => "https://www.test.int", :title => "Test"}
    bookmark_url = last_response.body
    id = bookmark_url.split("/").last

    put "/bookmarks/#{id}", {:title => "Success"}
    expect(last_response.status).to eq(204)

    get "/bookmark/#{id}"
    retrieved_bookmark = JSON.parse(last_response.body)
    expect(retrieved_bookmark["title"]).to eq("Success")
  end
    
end
