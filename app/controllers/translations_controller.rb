class TranslationsController < ApplicationController
 
  def create
    @document=Document.find(params[:document_id])
    @input=@document.translations.build(result: @document.diff,language: params[:language],target: params[:target])
    if @input.language==@input.target
      flash[:danger] = '原文と翻訳する言語は変えてください。'
      redirect_back(fallback_location: root_path)
    else 
    @result=translate(@input.result,@input.language,@input.target)
      
    if @translation = @input.update(result: @result)
      flash[:success] = '翻訳しました。'
      redirect_to document_url(@document)
    else
      @translations = @document.translations.order(id: :desc).page(params[:page])
      flash.now[:danger] = '翻訳に失敗しました。'
      redirect_back(fallback_location: root_path)
    end
    end
  end

  def edit
    @translation=Translation.find_by(result: params[:result])
  end

  def update
    @document=Document.find(params[:document_id])
    @translation=@document.translations.find(params[:id])
    if @translation.update(translation_params)
      flash[:success] = 'Document は正常に更新されました'
      redirect_to document_url(@document)
    else
      flash.now[:danger] = 'Document は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @translation =Translation.find(params[:id])
    @translation.destroy
    flash[:success] = '文書を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def translate(q ,input, output)
  require 'net/http'
  require 'uri'
  require 'json'
  url = URI.parse('https://www.googleapis.com/language/translate/v2')
  params = {
    q: q,
    target: output,
    source: input,
    key: "AIzaSyAiqqgyxea9RVUcTbKYuQueQYziBKEFl0c"
  }
  url.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(url)
  JSON.parse(res.body)["data"]["translations"].first["translatedText"]
  end
  
  def translation_params
    params.require(:translation).permit(:result,:document_id,:language,:target)
  end
  
end
