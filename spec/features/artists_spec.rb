require 'spec_helper'

feature 'Artists' do
  before(:each) do
    @artist = create(:artist)
    @artist2 = create(:artist2)
    # these two lines ensure the 2 artists are in the db for the tests
    # For convenience, they are also saved as variables useable throughout our code
  end  



  describe "Home Page", :type => :feature do
    it 'displays link to artist#index page' do
      visit root_path
      # page.should have_selector('h1')
      # find('h1').should have_content('HOME')
      current_path.should eq root_path
      click_link("Artists")
      # page.should_not have_selector('h1')
      # page.should have_selector('h2')
      # find('h1').should have_content('Artists')
      current_path.should eq artists_path
    end
  end



  describe "Artists Index page", :type => :feature do
    before { visit artists_path }

    it 'displays link to artist#new' do
      current_path.should eq artists_path
      click_link('New Artist')
      current_path.should eq new_artist_path
    end
    it 'has a table with a head and rows' do
      page.should have_xpath('//table/thead/th')
      page.should have_xpath('//table/tbody/tr/td')
    end
    it 'displays info about all artists' do
      # page.should have_content(@artists)
      find('table').should have_content(:artist_name)
      find('table').should have_content(:artist_url)
      find('table').should have_content(:artist2_name)
      find('table').should have_content(:artist2_url)
    end
    it 'displays link to artist#show page' do
      find('tbody tr:nth-child(1) td:nth-child(1) a').click
      current_path.should eq artist_path(@artist)
    end
    it 'displays link to artist#edit' do 
      find('tbody tr:nth-child(1) td:nth-child(3) a').click
      current_path.should eq edit_artist_path(@artist)
    end
    it 'displays link to artist#destroy' do
      find('tbody tr:nth-child(1) td:nth-child(4) a').click
      Artist.count.should eq 1
    end
  end



  describe 'New Artist Page', :type => :feature do
    it 'allows user to make a new artist' do
      visit new_artist_path
      page.should have_selector('form#new_artist')

      within('form#new_artist') do
        fill_in 'artist_name', :with => 'Mike'
        fill_in 'artist_url', :with => 'mike.jpg'
        find_field('artist_name').value.should eq 'Mike'
        find_field('artist_url').value.should eq 'mike.jpg'
        click_button('Create Artist')
        # save_and_open_page
      end
      current_path.should eq artists_path
      (Artist.count).should eq 3
      page.should have_content('Mike')
    end
  end



  describe 'Artist Show Page' do
    before { visit artist_path(@artist) }

    it "displays the artists name" do
      page.should have_content(@artist.name)
      page.should_not have_content(@artist2.name)
    end
    it 'displays an image of the artist' do
      page.should have_selector("img[src='#{@artist.url}']")
      page.should_not have_selector("img[src='#{@artist2.url}']")
    end
  end



  describe 'Edit Artist Page' do
    it 'has a form with the artists info' do 
      visit edit_artist_path(@artist)
      page.should have_css("form#edit_artist_#{@artist.id.to_s}")
      within('form') do
        find_field('artist_name').value.should eq @artist.name
        find_field('artist_url').value.should eq @artist.url
      end
    end

    it 'saves changes made in the form once submit is clicked' do
      visit edit_artist_path(@artist)
      @old_name = @artist.name
      @new_name = 'Mike'
      within('form') do
        fill_in('artist_name', :with => @new_name)
      end
      find("input[value='Update Artist']").click
      current_path.should eq artist_path(@artist)
      page.should have_content @new_name
      page.should_not have_content @old_name
    end
  end
end


