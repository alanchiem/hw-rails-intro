class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings

      # Pt 3. check if params[] is nil
      if params[:ratings] == nil
        if session[:ratings] == nil
          @ratings_to_show = ['G','PG','PG-13','R']
        end
        @ratings_to_show = session[:ratings_to_show]
      else
        @ratings_to_show = params[:ratings].keys
        session[:ratings_to_show] = @ratings_to_show
      end
      @movies = Movie.with_ratings(@ratings_to_show)

      @title_highlight = "p-3 mb-2 bg-transparent text-dark"
      @date_highlight = "p-3 mb-2 bg-transparent text-dark"


      if params[:title_clicked]
        @movies = @movies.order(:title)
        @title_highlight ="p-3 mb-2 bg-warning text-dark"

        session[:title_clicked] = true
        session[:date_clicked] = false

      elsif params[:date_clicked] 
        @movies = @movies.order(:release_date).reverse_order
        @date_highlight ="p-3 mb-2 bg-warning text-dark"

        session[:date_clicked] = true
        session[:title_clicked] = false

      elsif session[:title_clicked]
        @movies = @movies.order(:title)
        @title_highlight ="p-3 mb-2 bg-warning text-dark"

      elsif session[:date_clicked] 
        @movies = @movies.order(:release_date).reverse_order
        @date_highlight ="p-3 mb-2 bg-warning text-dark"
      
      end 
      

    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end