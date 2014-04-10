var LikeForm = {
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
};