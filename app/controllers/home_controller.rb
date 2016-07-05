class HomeController < ApplicationController
  def index
    if(params.has_key?(:syn) && params.has_key?(:rhyme))
      render :json => {syn: params[:syn], rhyme: params[:rhyme], test: "success"};
    end
  end
end
