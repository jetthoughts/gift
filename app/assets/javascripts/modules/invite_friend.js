var InviteFriend = {
  initialize:function (dialog, fb_friends_ids) {
    Facebook.initialize();
    InviteFriend._addEventHandlers();
    InviteFriend.dialog = $(dialog);
    InviteFriend.fb_friends_ids = fb_friends_ids;
  },

  _updateFbFriendStatus:function (fuid) {
    $("a.invite_fb_friend[rel=" + fuid + "]").replaceWith('Invite Sent');
  },

  fbToCallback:function (res) {
    if (InviteFriend.fbCallback(res)) {
      InviteFriend._updateFbFriendStatus(res.to[0]);
    }
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
    $.ajax({
      url:"/plan/user_friends.json",
      data:{user_friend_attributes:data},
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

    $('#share_email_link a').click(function () {
      Popups.showFromLink(this);
      InviteFriend.dialog.find('a:first').click();
      return false;
    });

    $('#email-composer-form').live('ajax:complete',
        function (event, xhr) {
          $('#email-composer-form .info-messages').html(xhr.responseText);
        }).live('ajax:success', function () {
          setTimeout(InviteFriend._afterSendMail, 2000);
        });
  },

  _afterSendMail:function () {
    $("#email-composer-form #emails").val('');
  }
};