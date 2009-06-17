module RatingStars
  module RatingStarsHelper

    protected

    include CssTemplate
    
    def rating_stars(opts={})
      html = []
      html << render_css('rating_stars/rating_stars') if opts[:generate_css] == true
      concat html.join
      return nil
    end

  end
end
