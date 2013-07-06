require 'spec_helper'

feature 'Artists' do
  before(:each) do
    create(:artist)
    create(:artist2)
    # these two lines ensure the 2 artists are in the db for the tests
  end  

  describe "navigation from home page", :type => :feature do
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

  describe "Artists page", :type => :feature do
    it 'displays link to artist#new' do
      visit artists_path
      find('h1').should have_content('Artists')
      click_link('New Artist')
      find('h1').should have_content('New Artist')
    end
    it 'has a table with a head and rows' do
      visit artists_path
      page.should have_xpath('//table/thead/th')
      page.should have_xpath('//table/tbody/tr')
      # page.has_xpath?('//table/tr')
      # page.has_css?('table tr.foo')
      # page.has_content?('foo')
      # page.should have_xpath('//table/tr')
    end
    it 'has rows with info about artists'

    it 'displays link to artist#show' do
      pending
      visit artists_path
      click_link('#{artist.name}')
      find('h1').should_not have_content('Artists')
      find('h1').should have_content('#{artist.name}')
    end
    it 'displays link to artist#edit'
    it 'displays link to artist#destroy'
  end

  describe 'New Artist Page', :type => :feature do
    it 'allows user to make a new artist' do
      visit new_artist_path
      page.should have_selector('form#new_artist')

      within('form#new_artist') do
        fill_in 'artist_name', :with => 'Mike'
        fill_in 'artist_url', :with => 'mike.com'
        find_field('artist_name').value.should eq 'Mike'
        find_field('artist_url').value.should eq 'mike.com'
        click_button('Create Artist')
        # save_and_open_page
      end
      current_path.should eq artists_path
      (Artist.count).should eq 3
    end
  end

  describe 'Artist Page' do
    it 'displays link to artist#show page' do

    end
  end
end


