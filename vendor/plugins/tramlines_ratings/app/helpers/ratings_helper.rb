module RatingsHelper
  
  def disabled_dislike_link(options = {})
    options.merge!(:class => "dislike_link disabled_dislike_link #{options[:class]}".strip)
    content_tag(:span, 'Dislike', options)
  end
  
  def disabled_like_link(options = {})
    options.merge!(:class => "like_link disabled_like_link #{options[:class]}".strip)
    content_tag(:span, 'Like', options)
  end

  def dislike_js(rating)
    "$('#rating_score_#{unique_rating_string(rating)}').val(-1); #{submit_js(rating)}"
  end

  # this differs to unlike because it adds a negative liking, where unlike removes the liking
  def dislike_link(rating, options = {})
    options.merge!(:class => "dislike_link #{options[:class]}".strip, :id => "dislike_link_#{unique_rating_string(rating)}", :title => 'Dislike')
    return content_tag(:span, 'Dislike', options) if !rating.new_record? && rating.negative?
    link_to_function("Dislike", dislike_js(rating), options)
  end
  
  def disliking_name_list(rateable)
    rating_name_list(rateable, "dis")
  end
  
  def like_and_dislike_links(rating)
    returning out = '' do
      out << like_link(rating, :class => "polarized_like_link")
      out << dislike_link(rating, :class => "polarized_dislike_link")
    end
  end
  
  # include this in the head
  def like_form_javascript
    javascript_tag do
      "var LikeForm = {
        loading: function(unique_rating) {
          var like_form_id = '#like_form_'+unique_rating;
          $(like_form_id + ' .like_links').hide(0, function() {
            $(like_form_id + ' .like_loader').show();
          });
        },
        complete: function(unique_rating) {
          var like_form_id = '#like_form_'+unique_rating;
          $(like_form_id + ' .like_loader').hide(0, function() {
            $(like_form_id + ' .like_links').show();
          });
        }
      };"
    end
  end
  
  def like_form(rating, options = {})
    render('ratings/like_form', options.merge(:rating => rating))
  end
  
  def like_js(rating)
    "$('#rating_score_#{unique_rating_string(rating)}').val(1); #{submit_js(rating)}"
  end
  
  def like_link(rating, options = {})
    options.merge!(:class => "like_link #{options[:class]}".strip, :id => "like_link_#{unique_rating_string(rating)}", :title => 'Like')
    return content_tag(:span, 'Like', options) if !rating.new_record? && rating.positive?
    link_to_function("Like", like_js(rating), options)
  end

  def liking_name_list(rateable)
    rating_name_list(rateable)
  end
  
  def rating_for(rateable)
    rateable.ratings.for_member(logged_in_member).first || rateable.ratings.build(:member => logged_in_member)
  end
  
  def rating_link(rating, polarized = false, allow_unlike = true)
    if polarized
      like_and_dislike_links(rating)
    else
      (rating.new_record? || !allow_unlike) ? like_link(rating) : unlike_link(rating)
    end
  end
  
  def rating_name_list(rateable, prefix = '')
    rating_members = rateable.send("#{prefix}liking_members").dup
    if rating_members.include?(logged_in_member)
      rating_members.delete(logged_in_member)
      rating_members.unshift(logged_in_member)
    end
    rating_members.map {|member| link_to(you_or_full_name(member), member)}.to_sentence + " #{prefix}like this"
  end

  def render_like_link_for(rateable, options = {})
    options.reverse_merge!(:hide_if_logged_out => false, :disable_if_logged_out => false)
    return "" if !rateable.is_rateable? || RAILS_ENV == 'test'
    if logged_out?
      return "" if options[:hide_if_logged_out]
      if options[:disable_if_logged_out]
        return disabled_like_link if !options[:polarized]
        content_tag(:div, disabled_like_link + disabled_dislike_link, :class => "like_links")
      else
        out = link_to_login_fancybox("Like", :class => "like_link")
        options[:polarized] ? content_tag(:div, out + link_to_login_fancybox("Dislike", :class => "dislike_link"), :class => "like_links") : out
      end
    else
      rating = rating_for(rateable)
      options.reverse_merge!(:rateable => rateable, :rating => rating, :ajax_loader => "ajax_loader.gif", :polarized => false, :allow_unlike => true)
      render("ratings/like_form", options)
    end
  end
  
  def render_like_list_for(rateable, options = {})
    return "" if !rateable.is_rateable?
    options.reverse_merge!(:rateable => rateable)
    render("ratings/like_list", options)
  end

  def unique_rating_string(rateable)
    rateable = rateable.rateable if rateable.is_a?(Rating)
    "#{rateable.class.to_s.downcase}_#{rateable.id}"
  end

  # this differs to dislike because it removes the liking, where dislike adds a negative liking
  def unlike_link(rating)
    link_to_remote("Unlike", :url => rating_path(rating), :method => :delete, 
                   :loading => "LikeForm.loading('#{unique_rating_string(rating)}')", 
                   :complete => "LikeForm.complete('#{unique_rating_string(rating)}')", 
                   :html => {:class => "unlike_link", :id => "unlike_link_#{unique_rating_string(rating)}"})
  end

  def update_like_counts_for(rateable, page)
    unique_rateable = unique_rating_string(rateable)
    page["#likings_count_#{unique_rateable}"].replace(content_tag(:span, rateable.likings_count_string, :id => "likings_count_#{unique_rateable}", :class => "likings_count #{rateable.been_liked? ? '' : 'no_ratings'}"))
    page["#dislikings_count_#{unique_rateable}"].replace(content_tag(:span, rateable.dislikings_count_string, :id => "dislikings_count_#{unique_rateable}", :class => "dislikings_count #{rateable.been_disliked? ? '' : 'no_ratings'}"))
  end
  
  private
  def submit_js(rating)
    "$('#rating_submit_#{unique_rating_string(rating)}').click();"
  end  
  
end
