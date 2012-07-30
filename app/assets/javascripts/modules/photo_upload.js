var PhotoUpload = window.PhotoUpload = {
    update_profile: function(id){
       $.post('/users/profile', {'_method': 'PUT', attachment_id: id});
    },

    initialize : function(url, onSuccess) {
        new AjaxUpload('upload_button', {
            responseType: 'json',
            action:url,
            data: {
                authenticity_token: $('input[name=authenticity_token]').val(),
                attachment_id: $('input[name=attachment_id]').val(),
                action : "update",
                _method : "put"
            },
            onSubmit : function() {
                $('.ajax-loader-indicator').removeClass('hide');
            },
            onComplete: function(file, response) {
                if (response.url) {
                    $('#avatar_image').attr('src', response.orig_url + "?time=" + new Date().getTime());
                    $('input[name=attachment_id]').val(response.attachment_id);
                    if (typeof(onSuccess) == "function"){
                      onSuccess(response.attachment_id);
                    }
                } else if (response.error) {
                    alert('An error occurred while loading this picture. Please make sure that the picture format is .png, .jpg, or .gif and that the picture size is less than 2 MB.');
                }
                $('.ajax-loader-indicator').addClass('hide');
            }
        })
    }

};