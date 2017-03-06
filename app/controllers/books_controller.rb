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
    @input_title = params[:title]
    @input_size = params[:content][:id]
    @input_isbn = params[:isbn]
    @error = ""
    uri = 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522?applicationId=1097463767217933326'

    #htmlからパラメータを受け取り代入する
    if @input_title.length < 2 && @input_isbn == ""
      @error = "error　２文字以上で入力してください"
      return false
    end
    parameter = {
      title: @input_title,
      author: '',
      size: @input_size, #書籍の種類についてのパラメータ
      isbn: @input_isbn, #isbnコードのパラメータ
    }

    #render :text => parameter #デバッグ用
    #return false

    def make_url uri, parameter
      url = uri

      if @input_isbn != ""
        url += "&isbn=#{@input_isbn}"
        return url
      else
        parameter.each do |key, value|
          tmp = CGI.escape(value)
          url += "&#{key}=#{tmp}" unless value == '' && key = "isbn"#valueが空でなくて
        end
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
        return 'error'
      end
    end

    request_url = make_url uri, parameter
    #render :text => request_url  #デバッグ用
    #return false
    json = get_json request_url
    if json == 'error'
      @error = "データの取得に失敗しました"
      return false
    elsif json["hits"] == 0
      @error = "データが存在しませんでした"

    else
      items = json["Items"]
      # resultを使ってなんやかんや処理をする
      @data = []
      @hits = json["hits"]
      for i in 0..(@hits - 1) do


        input = {
          title: items.dig(i,"Item", "title"),
          subTitle: items.dig(i, "Item", "subTitle"),
          author: items.dig(i, "Item", "author"),
          size: items.dig(i, "Item", "size"),
          isbn: items.dig(i, "Item", "isbn"),
          itemUrl: items.dig(i, "Item", "itemUrl"),
          imageUrl: items.dig(i, "Item", "largeImageUrl"),
        }
        @data[i] = input
      end
    end
    #redirect_to books_search_result_path(@data)

  end
end
