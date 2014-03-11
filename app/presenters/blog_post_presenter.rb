# app/presenters/blog_post_presenter.rb

class BlogPostPresenter < Struct.new(:blog_post)
  include ActionView::Helpers::TagHelper

  delegate :author, :blog, :content, :content_type, :published_at, :published?,
    :taggings, :title, :to => :blog_post

  def author_name
    author.email
  end # method author_name

  def localized_content_type locale = I18n.locale
    I18n.t(content_type, :scope => 'blog_post.content_types', :locale => locale)
  end # method localized_content_type

  def formatted_content
    case content_type
    when 'plain'
      PlainTextFormatter.new(content).format
    when 'redcarpet'
      RedcarpetFormatter.new(content).format
    end # case
  end # method formatted_content
  
  def published_date format: :long
    published? ? I18n.l(published_at, :format => format) : nil
  end # method published_date

  def raw_content
    RawContentFormatter.new(content).format
  end # method raw_content

  def taggings_list
    taggings.blank? ?
      I18n.t('models.taggable.empty_taggings') :
      tagging_names.join(', ') + '.'
  end # method taggings_list

  def tagging_names
    taggings.map(&:name).sort
  end # method tagging_names

  class ContentFormatter < Struct.new(:content)
    def format
      content
    end # method format
  end # class

  class RawContentFormatter < ContentFormatter
    include ERB::Util

    def format
      html_escape(content).gsub(/\r\n|\n|\r/, '<br />').html_safe
    end # method format
  end # class

  class PlainTextFormatter < RawContentFormatter
    def format
      "<p>#{content.blank? ? I18n.t('blog_post.empty_content') : super}</p>".html_safe
    end # method format
  end # class

  class RedcarpetFormatter < ContentFormatter
    EXTENSIONS = {
      :fenced_code_blocks  => true,
      :footnotes           => true,
      :no_intra_emphasis   => true,
      :space_after_headers => true,
      :strikethrough       => true,
      :tables              => true,
      :underline           => true,
    } # end hash

    def format
      parser.render(content).strip.html_safe
    end # method format

    private

    def parser
      ::Redcarpet::Markdown.new(renderer, EXTENSIONS)
    end # method parser

    def renderer
      ::Redcarpet::Render::HTML.new
    end # method renderer
  end # class
end # class
