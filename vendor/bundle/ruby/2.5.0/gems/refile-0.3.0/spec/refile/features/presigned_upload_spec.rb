require "refile/test_app"

feature "Direct HTTP post file uploads", :js do
  scenario "Successfully upload a file" do
    visit "/presigned/posts/new"
    fill_in "Title", with: "A cool post"
    attach_file "Document", path("hello.txt")

    expect(page).to have_content("Upload started")
    expect(page).to have_content("Upload complete token accepted")
    expect(page).to have_content("Upload success token accepted")

    click_button "Create"

    expect(page).to have_selector("h1", text: "A cool post")
    result = Net::HTTP.get_response(URI(find_link("Document")[:href])).body.chomp
    expect(result).to eq("hello")
  end

  scenario "Fail to upload a file that is too large" do
    visit "/presigned/posts/new"
    fill_in "Title", with: "A cool post"
    attach_file "Document", path("large.txt")

    expect(page).to have_content("Upload started")
    expect(page).to have_content("Upload failure too large")
  end
end

