class DocumentsController < ApplicationController
  
  def show
    # @document=current_user.documents.find(params[:id])
    @document = Document.find(params[:id])
  end
  
  def new
    @document=current_user.documents.new
  end
  
  def create
@user=current_user    
@upload=current_user.documents.build(document_params)
require 'google/apis/vision_v1'
vision = Google::Apis::VisionV1::VisionService.new
vision.key = "AIzaSyBDt7-hHG8kDD-PhgNXeedy4_hRQmiX1YQ"
filename=File.open(@upload.image.path)

request = Google::Apis::VisionV1::BatchAnnotateImagesRequest.new(
  requests: [
    {
      image:{
        content: File.read(filename)
      },
      features: [
        {
          type: 'TEXT_DETECTION',
          maxResults: 1
        }
      ]
    }
  ]
)
result = vision.annotate_image(request) do |result, err |
  unless err then
    result.responses.each do | res |
      @str = res.text_annotations[0].description
    end
  end
end
 
    
    if @document = @upload.update(content: @str)
      flash[:success] = '画像を文書に変換しました。'
      redirect_to root_url
      else
      @documents = current_user.documents.order(id: :desc).page(params[:page])
      flash.now[:danger] = '画像のアップロードに失敗しました。'
      render :new
    end
  end
  
  def edit
    @document=current_user.documents.find(params[:id])
    @user=current_user
  end
  
  def update
    @document=current_user.documents.find(params[:id])

    if @document.update(document_params)
      flash[:success] = 'Document は正常に更新されました'
      redirect_to @document
    else
      flash.now[:danger] = 'Document は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:success] = '文書を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  
  private

  def document_params
    params.require(:document).permit(:image,:content)
  end
  def correct_user
    @document = current_user.documents.find_by(id: params[:id])
    unless @document
      redirect_to root_url
    end
  end
  
end
