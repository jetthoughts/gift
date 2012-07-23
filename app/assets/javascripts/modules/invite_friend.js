var InviteFriend = {
  initialize:function (dialog) {
    Facebook.initialize();
    InviteFriend._addEventHandlers();
    InviteFriend.dialog = $(dialog);
    InviteFriend._parseFriendsIds();
  },

  _parseFriendsIds:function () {
//  InviteFriend.fb_friends_ids
    invite_ids_text = $('.invite_ids').text();
    InviteFriend.fb_friends_ids = jQuery.parseJSON(invite_ids_text);
    console.log(InviteFriend.fb_friends_ids);
  },

  fbCallback:function (res) {
    if (!res) return false;

    var data = [];
    for (var i = 0; i < res.to.length; i++) {
      var fuid = res.to[i];

      if (-1 === $.inArray(fuid, InviteFriend.fb_friends_ids)) {
        InviteFriend.fb_friends_ids.push(fuid);
      }
      data.push({friend_uid:fuid, friend_name:Facebook.getFriendName(fuid)})
    }
    InviteFriend._createInvites(data);
    return true;
  },

  _createInvites:function (data) {
    var projectId = location.pathname.split('/')[2];
    $.ajax({
      url:"/invites/friends.json",
      data:{friend_attributes:data, project_id: projectId},
      type:'POST',
      context:this,
      dataType:"json",
      error:function () {
      },
      complete:function () {
      },
      success:function (res) {
      }});
  },

  filterFriends:function () {
    $("#fb_friends_list .fb_friend:hidden").show();
    var filter = $('#filter').val();
    if (filter.length > 0) {
      $("#fb_friends_list .fb_friend .fb_friend_name::not(:contains(" + filter + "))").parents('.fb_friend').hide();
    }
  },

  _addEventHandlers:function () {

    $('#fb-invite-link').click(function () {
      Facebook.fbInvite(InviteFriend.fb_friends_ids);
    });

    $('#update_token_link').live('click', function () {
      Facebook.login();
      return false;
    });

    $('#invite_content a.delete').live('click', function () {
      $(this).parents(".user_friend").remove();
    });

    $('a.invite_fb_friend').live('click', function () {
      var to = $(this).attr('rel');
      Facebook.fbInvite(InviteFriend.fb_friends_ids, to);
      return false;
    });


    $('#filter').live('keyup', function (event) {
      InviteFriend.filterFriends();
    });

    $('#search_facebook_friends').live('click', function () {
      InviteFriend.filterFriends();
    });

    $("#send-mail-button").live("click", function () {
      var emails = $("#email-composer-form #emails").val().split(',');
      if (emails.length > 0) {
        var data = [];
        var msg = $("#email-composer-form #message").val();
        for (var i = 0; i < emails.length; i++) {
          var email = emails[i].trim();
          data.push({friend_email:email, message:msg});
        }
        InviteFriend._createInvites(data);
        InviteFriend._afterSendMail();
      }
      return false;
    });

    $("a.ajax_link").live('click', function () {
      link = $(this);

      link.parent().find('a.active').removeClass('active');
      link.addClass('active');
      $('#invite_content').html('');
      $('#invite_content').addClass('ajax-loading');
      $.ajax({
        url:link.attr('href'),
        data:{},
        dataType:"html",
        error:function () {
        },
        complete:function () {
          $('#invite_content').removeClass('ajax-loading');
        },
        success:function (res) {
          $('#invite_content').html(res);
        }});
      return false;
    });
  }
};