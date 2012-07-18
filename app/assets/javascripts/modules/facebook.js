var Facebook = window.Facebook = {};
(function (Controller) {

  var initialized = false;
  var _friends = [];
  var _authToken = '';
  var _userID = '';
  var lastRequestedOperation = null;

  Controller.initialize = function () {
    if (initialized) return;

    window.fbAsyncInit = function () {
      FB.getLoginStatus(authorizedOnFacebook);
    };

    initialized = true;

  };

  Controller.login = function () {
    FB.login(authorizedOnFacebook, {scope:'email, user_likes'});
  };

  Controller.logout = function () {
    FB.logout(function (response) {
      _userID = '';
      _authToken = '';
    });
  };

  Controller.fbInvite = function (exclude_ids, to) {
    if (!_authToken) {
      Facebook.login();
      lastRequestedOperation = function () {
        Facebook.fbInvite(to)
      };
      return false;
    }
    var params = {exclude_ids:exclude_ids, method:'apprequests', message:'See project.'};
    var callback = InviteFriend.fbCallback;
    if (to !== undefined) {
      params.to = to;
      callback = InviteFriend.fbToCallback;
    }
    FB.ui(params, callback);
    return true;

  };

  Controller.getFriendName = function (id) {
    res = id;
    for (var i = 0; i < _friends.length && res == id; i++) {
      if (_friends[i].id == id) res = _friends[i].name;
    }
    return res;
  };

  Controller.runDelayedOperation = function () {
    if (lastRequestedOperation != null) {
      lastRequestedOperation();
      lastRequestedOperation = null;
    }
  };


  Controller.linkToFB = function (url) {
    if (!_authToken) {
      Facebook.login();
      lastRequestedOperation = function () {
        Facebook.linkToFB(url);
      };
      return false;
    }

    $.ajax({type:"POST",
      url:url,
      dataType:'html',
      data:{token:_authToken, uid:_userID },
      success:function (res) {
        $("#link_to_facebook_block").html(res);
      }
    });
  };

  Controller.unlinkFB = function (url) {
    $.ajax({type:"POST",
      url:url,
      dataType:'html',
      data:{token:_authToken, uid:_userID },
      success:function (res) {
        $("#link_to_facebook_block").html(res);
      }
    });
    $.fancybox.close();
  };

  function _updateAccessToken() {
    $.post('/update_token', {token:_authToken}, function () {
      $("#facebook_link.active").click();
    });
  }

  function authorizedOnFacebook(response) {
    if (response.authResponse != null) {
      _authToken = response.authResponse.accessToken;
      _userID = response.authResponse.userID;
      _updateAccessToken();
      FB.api('/me/friends', function (response) {
        if (response.data) {
          _friends = response.data;
          Controller.runDelayedOperation();
        }
      });
    }
  }

})(Facebook);