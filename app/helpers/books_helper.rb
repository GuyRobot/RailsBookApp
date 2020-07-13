module BooksHelper
  def user_added_to_library? user, book
    user.libraries.where(user: user, book: book)
  end
end
