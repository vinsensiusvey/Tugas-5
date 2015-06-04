class ArticlesController < ApplicationController
    def index
        @articles = Article.all
    end

    def show
        @article = Article.find(params[:id])
        @comment = Comment.new
    end

    def new
        @article = Article.new
    end

    def edit
        @article = Article.find(params[:id])
    end

    def destroy
        @article = Article.find(params[:id])
        if @article.destroy
            redirect_to articles_path, :notice => "Delete article success."
        else
            redirect_to articles_path, :error => "Delete article failed."
        end
    end

    def create
        @article = Article.new(params_article)
        if @article.save
            redirect_to articles_path, :notice => "Create new article success."
        else
            render "new", :error => "Create new article failed"
        end
    end

    def update
        @article = Article.find(params[:id])
        if @article.update(params_article)
            redirect_to article_path(@article), :notice => "Update article success."
        else
            render "edit", :error => "Update article failed"
        end
    end

    def export_xlsx
        @article = Article.find(params[:id])
        respond_to do |format|
            format.xlsx
        end
    end

    def import_xlsx
        Article.import(params[:file])
        redirect_to articles_path, notice: "Products imported."
    end

    def import
    end

    private
        def article
            params.require(:article).permit(:title, :content)
        end
end
