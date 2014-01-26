# spec/presenters/blog_post_presenter.rb

require 'spec_helper'

RSpec.describe BlogPostPresenter do
  let(:attributes) { {} }
  let(:blog_post)  { FactoryGirl.build :blog_post, attributes }
  let(:instance)   { described_class.new blog_post }

  describe '#author' do
    it { expect(instance).to have_reader(:author) }
    it { expect(instance.author).to be == blog_post.author }
  end # describe

  describe '#blog' do
    it { expect(instance).to have_reader(:blog) }
    it { expect(instance.blog).to be == blog_post.blog }
  end # describe

  describe '#blog_post' do
    it { expect(instance).to have_reader(:blog_post) }
    it { expect(instance.blog_post).to be == blog_post }
  end # describe

  describe '#content' do
    it { expect(instance).to have_reader(:content) }
    it { expect(instance.content).to be == blog_post.content }
  end # describe

  describe '#content_type' do
    it { expect(instance).to have_reader(:content_type) }
    it { expect(instance.content_type).to be == blog_post.content_type }
  end # describe

  describe '#published_at' do
    it { expect(instance).to have_reader(:published_at) }
    it { expect(instance.published_at).to be == blog_post.published_at }
  end # describe

  describe '#published?' do
    it { expect(instance).to respond_to(:published?).with(0).arguments }
    it { expect(instance.published?).to be == blog_post.published? }
  end # describe

  describe '#title' do
    it { expect(instance).to have_reader(:title) }
    it { expect(instance.title).to be == blog_post.title }
  end # describe

  describe '#author_name' do
    let(:author)     { FactoryGirl.create :user }
    let(:attributes) { super().merge :author => author }

    it { expect(instance).to respond_to(:author_name).with(0).arguments }
    it { expect(instance.author_name).to be == author.email }
  end # describe

  describe '#localized_content_type' do
    let(:i18n_scope) { "blog_post.content_types" }

    it { expect(instance).to respond_to(:localized_content_type).with(0..1).arguments }
    it { expect(instance.localized_content_type).to be == I18n.t(instance.content_type, :scope => i18n_scope) }

    context 'with a locale' do
      let(:locale) { 'sjn' }
      let(:value)  { 'sindarin'}

      it 'invokes I18n.t' do
        expect(I18n).to receive(:t).with(instance.content_type, :scope => i18n_scope, :locale => locale).and_return(value)
        expect(instance.localized_content_type locale).to be == value
      end # it
    end # context
  end # describe

  describe '#formatted_content' do
    let(:content)      { nil }
    let(:content_type) { nil }
    let(:attributes) do
      super().merge :content => content, :content_type => content_type
    end # let

    it { expect(instance).to respond_to(:formatted_content).with(0).arguments }

    context 'as plain text' do
      let(:content_type) { 'plain' }

      context 'with a simple string content' do
        let(:content)   { 'My name is Ozymandias, king of kings!' }
        let(:formatted) { "<p>#{content}</p>" }

        it { expect(instance.formatted_content).to be == formatted }
      end # context

      context 'with an empty string' do
        let(:content)   { '' }
        let(:formatted) { "<p>#{I18n.t('blog_post.empty_content')}</p>" }

        it { expect(instance.formatted_content).to be == formatted }
      end # context
    end # context

    context 'as redcarpet markdown' do
      let(:content_type) { 'redcarpet' }

      context 'with a simple string content' do
        let(:content)   { 'My name is Ozymandias, king of kings!' }
        let(:formatted) { "<p>#{content}</p>" }

        it { expect(instance.formatted_content).to be == formatted }
      end # context

      context 'with a header and content' do
        let(:content)   { "# Header\n\nContent paragraph here." }
        let(:formatted) { "<h1>Header</h1>\n\n<p>Content paragraph here.</p>" }

        it { expect(instance.formatted_content).to be == formatted }
      end # context
    end # context
  end # describe

  describe '#published_date' do
    it { expect(instance).to respond_to(:published_date).with(0, :format).arguments }

    context 'with an unpublished post' do
      it { expect(instance.published_date).to be nil }
    end # context

    context 'with a published post' do
      let(:published_at) { Time.now.utc }

      before(:each) do
        allow(instance).to receive(:published?).and_return(true)
        allow(instance).to receive(:published_at).and_return(published_at)
      end # before each

      it { expect(instance.published_date).to be == I18n.l(published_at, :format => :long) }

      context 'with a format argument' do
        let(:format) { :short }

        it { expect(instance.published_date format: format).to be == I18n.l(published_at, :format => format) }
      end # context
    end # context
  end # describe

  describe '#raw_content' do
    let(:content)    { nil }
    let(:attributes) { super().merge :content => content }

    it { expect(instance).to respond_to(:raw_content).with(0).arguments }

    context 'with a simple string content' do
      let(:content) { 'My name is Ozymandias, king of kings!' }

      it { expect(instance.raw_content).to be == content }
    end # context

    context 'with a multi-line content' do
      let(:content) do
        "The lights begin to twinkle on the rocks\n" +
        "The long day wanes, the slow moon climbs, the deep\r\n" +
        "\n" +
        "Moans round with many voices."
      end # let
      let(:formatted) { content.gsub(/(\r\n|\n)/, '<br />') }

      it { expect(instance.raw_content).to be == formatted }
    end # context

    context 'with a multi-line html content' do
      let(:content) do
        "<h1>My Purpose</h1>\n" +
        "<p><strong>To Sail Beyond:</strong></p>\n" +
        "<ul>" +
        "  <li>The Sunset</li>\n" +
        "  <li>Baths of All The Western Stars</li>\n" +
        "</ul>"
      end # let
      let(:formatted) { CGI::escapeHTML(content).gsub(/(\r\n|\n)/, '<br />') }

      it { expect(instance.raw_content).to be == formatted }
    end # context
  end # describe
end # describe
