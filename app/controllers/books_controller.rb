class BooksController < ApplicationController

  def index
    @presenter = BooksPresenter.new(params)
  end
  
  def create
    Book.create(params[:book])
  end

  def update
    book = Book.find(params[:id])
    book.update!(book_params)
    redirect_to book
  end
 
  private
  
	def book_params
		params.require(:book).permit(:title, :description, :authors, :isbn, :publication_date, :genres, :price, :hidden)
	end

end
