require 'spec_helper'
# STUBBING AND MOCKING CLEARLY SEPARATES TESTING
# THE MODEL FROM TESTING THE CONTROLLERS
# THIS SPEEDS UP THE CONTROLLER TESTING BC YOU ARE NOT
# HITTING THE DATABASE AND IT DECOUPLES YOUR TESTING (GOOD)


describe ArtistsController do
  describe 'collection' do
    # making the describe 'collection' really only serves
    # to parallel the describe 'member' section.
    describe 'GET #index' do #----------------------------------------------------------------------------------------------------------
      it 'saves all artists as instance variable' do 
        artist = create(:artist)
        artist2 = create(:artist2)
        get :index
        assigns(:artists).should eq [artist, artist2]
      end
      it 'renders the :index view' do 
        get :index
        response.should render_template :index
      end
    end

    describe "GET #new" do #------------------------------------------------------------------------------------------------------------
      let(:artist) { mock_model(Artist).as_new_record }
      # if we dont designate that it should be mocked as a new record,
      # we will fail the test that it should be_new_record
      before { Artist.stub(:new).and_return(artist) }

      it 'assigns a new artist as an instance variable' do 
        get :new
        assigns(:artist).should be_an_instance_of(Artist)
        assigns(:artist).should be_new_record
      end

      it 'renders the :new view' do
        get :new
        response.should render_template :new
      end
    end

    describe 'POST #create' do #--------------------------------------------------------------------------------------------------------
      let(:artist) { mock_model(Artist).as_null_object }
      # as_null_object allows it to ignore all the method calls
      # and thus will not render any errors as a result
      before { Artist.stub(:new).and_return(artist) }

      context 'when save succeeds' do
        it 'saves the artist' do
          artist.should_receive(:save)
          # artist should be receiving the method save,
          # as in artist.save
          post :create
        end

        it 'redirects to artists index page' do
          # artist.should_receive(:save)
          post :create
          response.should redirect_to artists_path
        end

        # it 'creates a new artist' do 
        #   expect{
        #     post :create, {artist: attributes_for(:artist)}
        #     }.to change{Artist.count}.by 1
        # end
        # it 'redirects to artists index page' do
        #   post :create, {artist: attributes_for(:artist)}
        #   response.should redirect_to artists_path
        # end
      end

      context 'when save fails' do
        it 'renders new page' do
          artist.should_receive(:save).and_return(false)
          post :create
          response.should render_template :new
        end
      end


      context 'with invalid attributes' do
        it 'does not create a new artist' do
          expect{
            post :create, {artist: attributes_for(:invalid_artist)}
            }.to change{Artist.count}.by 0
        end
        it 'renders the :new view' do 
          post :create, {artist: attributes_for(:invalid_artist)}
          response.should render_template :new
        end
      end
    end
  end

  describe 'member' do
    # member routes need to know the instance they are acting upon
    # therefore you need to pass in an object

    # let(:artist) { create(:artist) }
    # let makes a local variable within each block,
    # so you dont have to use an instance variable

    let(:artist) { mock_model(Artist) }
    # THIS IS HOW YOU MAKE A MOCK MODEL
    # mock_model is an rspec method (basically). 
    # we are passing in the class we want to model
    describe 'GET #edit' do
      before { get :edit, id: artist }
      #  ^ syntax for doing a before block in one line
      it 'saves the given artist as an instance variable' do
        assigns(:artist).should eq artist
      end
      it 'renders the :edit view' do
        response.should render_template :edit
      end
    end

    describe 'GET #show' do
      before do 
        Artist.stub(:find).and_return(artist)
        # ^ When, in the controller, the program comes across 'find' - 
        # just return an artist instead of the method find
        get :show, id: artist
      end
      it 'saves the given artist as an instance variable' do
        assigns(:artist).should eq artist
      end
      it 'renders the :show view' do
        response.should render_template :show
        # these really short blocks can be refactored to one line
        # see RSpec Code School for more info
      end
    end

    describe 'PUT #update' do
      context 'valid attributes' do
        before { put :update, id: artist, artist: attributes_for(:artist) }
        # we need to pass more than just the id, we also need the attributes.
        # in the edit test, we only needed the id to identify the artist we were changing
        it 'assigns the given artist to an instance variable' do
          assigns(:artist).should eq artist
        end

        it 'changes the attributes of the artist' do 
          expect {
            put :update, id: artist, artist: attributes_for(:artist, name: 'Mike') 
            artist.reload
            # artist is in the memory. we are trying to update that copy of the artist
            # in memory. now that we have changed the database, the memory copy is invalid
          }.to change{artist.name}.to('Mike')
          
          expect {
            put :update, id: artist, artist: attributes_for(:artist, url: 'mike.com') 
            artist.reload 
          }.to change{artist.url}.to('mike.com')
        end
        it 'redirects to the artist page' do
          response.should redirect_to artist_path(artist)
        end
      end
      context 'invalid attributes' do  
        it 'does not assign the attributes to the artist' do
          expect {
             put :update, id: artist, artist: attributes_for(:invalid_artist)  
          }.to_not change{artist.name}          
        end

        it 're-renders the edit page' do 
          put :update, id: artist, artist: attributes_for(:invalid_artist)
          response.should render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the artist' do
        artist.reload
        expect {
          delete :destroy, id: artist
        }.to change{Artist.count}.by -1
      end
      it 'redirects to the artist index page' do
        delete :destroy, id: artist
        response.should redirect_to artists_path
      end
    end
  end
end