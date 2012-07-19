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
    FB.login(authorizedOnFacebook, {scope:'email, create_event'});
  };

  Controller.logout = function () {
    FB.logout(function (response) {
      _userID = '';
      _authToken = '';
    });
  };

  Controller.fbInvite = function (exclude_ids, to, message) {
    if (!_authToken) {
      Facebook.login();
      lastRequestedOperation = function () {
        Facebook.fbInvite(to)
      };
      return false;
    }

    if (message === undefined) {
      message = "See my project"
    }

    var params = {/*exclude_ids:exclude_ids,*/ method:'apprequests', message:message};
    var callback = InviteFriend.fbCallback;
    if (to !== undefined) {
      params.to = to;
      callback = InviteFriend.fbToCallback;
    }

    console.log(params);
    console.log(params.to);

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