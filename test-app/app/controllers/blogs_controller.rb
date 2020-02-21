# frozen_string_literal: true

require "fileutils"

class BlogsController < ApplicationController
  # POST /blogs
  def create
    @blog = Blog.create(params.require(:blog).permit(:title, :content))
    respond_with @blog
  end

  # Put /blogs/1
  def upload
    @blog = Blog.find_by_id(params[:id])
    return head :not_found if @blog.nil?

    @blog.thumbnail = save_uploaded_file params[:file]
    head @blog.save ? :ok : :unprocsessible_entity
  end

  # GET /blogs
  def index
    @blogs = Blog.all
    respond_with @blogs
  end

  # GET /blogs/1
  def show
    @blog = Blog.find_by_id(params[:id])

    fresh_when(@blog)
    return unless stale?(@blog)

    respond_with(@blog, status: :not_found) && return unless @blog
    respond_with @blog
  end

  private

  def save_uploaded_file(field)
    return if field.nil?

    file = File.join("public/uploads", field.original_filename)
    FileUtils.cp field.tempfile.path, file
    field.original_filename
  end
end
