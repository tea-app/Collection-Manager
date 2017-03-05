class BooksController < ApplicationController
  before_action :authenticate_user!
  def top
  end
  def detail
      @title = params[:title]
      @imageUrl = params[:imageUrl]
      @author = params[:author]
      @isbn = params[:isbn]
      @publisherName = params[:publisherName]
      @salesDate = params[:salesDate]
      @library1 = Library.find_by(isbn:params[:isbn], mode:0, user_id:current_user.id)
      @library2 = Library.find_by(isbn:params[:isbn], mode:1, user_id:current_user.id)
      if @library1.nil?
          @word1 = "books_btn have-btn1"
      else
          @word1 = "books_btn have-btn2"
      end
      if @library2.nil?
          @word2 = "books_btn read-btn1"
      else
          @word2 = "books_btn read-btn2"
      end
      #api(@isbn)
  end
  def db_have
      @judge= Library.find_by(isbn:params[:format], mode:0, user_id:current_user.id)
      if @judge.nil?
          @library = Library.new
          @library.isbn = params[:format]
          @library.mode = 0
          @library.user_id = current_user.id
          @library.save
      else
          @judge.destroy
      end
      redirect_to current_user
  end
  def db_read
      @judge= Library.find_by(isbn:params[:format], mode:1, user_id:current_user.id)
      if @judge.nil?
          @library = Library.new
          @library.isbn = params[:format]
          @library.mode = 1
          @library.user_id = current_user.id
          @library.save
          else
          @judge.destroy
      end
      redirect_to current_user
  end
  def search_result
      @title = params[:title]
      @size = params[:content][:id]
      @isbn = params[:isbn]
      uri = 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522?applicationId=1097463767217933326'
      
      #htmlからパラメータを受け取り代入する
      parameter = {
          title: @title,
          author: '',
          size: @size, #書籍の種類についてのパラメータ
          isbn: @isbn, #isbnコードのパラメータ
      }
      
      def make_url uri, parameter
          url = uri
          parameter.each do |key, value|
              tmp = CGI.escape(value)
              url += "&#{key}=#{tmp}" unless value == '' #それぞれのvalueが空でない時request_urlの後ろに追加する。
          end
          url
      end
      
      def get_json request_url
          res = open(request_url)
          code, message = res.status # res.status => ["200", "OK"]
          
          if code == '200'
              json = ActiveSupport::JSON.decode res.read
              return json
              else
              puts "OMG!! #{code} #{message}"  #error
              return 'error'
          end
      end
      
      request_url = make_url uri, parameter
      json = get_json request_url
      if json == 'error'
          puts "error"
          else
          items = json["Items"]
          # resultを使ってなんやかんや処理をする
          @data = []
          for i in 0..10 do
              
              
              input = {
                  title: items.dig(i,"Item", "title"),
                  subTitle: items.dig(i, "Item", "subTitle"),
                  author: items.dig(i, "Item", "author"),
                  size: items.dig(i, "Item", "size"),
                  isbn: items.dig(i, "Item", "isbn"),
                  publisherName: items.dig(i, "Item", "publisherName"),
                  salesDate: items.dig(i, "Item", "salesDate"),
                  itemUrl: items.dig(i, "Item", "itemUrl"),
                  imageUrl: items.dig(i, "Item", "largeImageUrl"),
              }
              @data[i] = input
          end
        end
          #redirect_to books_search_result_path(@data)

      end
end
