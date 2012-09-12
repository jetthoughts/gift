var PhotoUpload = window.PhotoUpload = {
    update_profile: function(id){
       $.post('/users/profile', {'_method': 'PUT', attachment_id: id});
    },
    default_preview_id : 'avatar_image',
    default_button_id : 'upload_button',
    initialize : function(url, onSuccess, preview_id, button_id) {
        var button_id =  typeof button_id !== 'undefined' ? button_id : PhotoUpload.default_button_id;
        var preview_id = typeof preview_id !== 'undefined' ? preview_id : PhotoUpload.default_preview_id;
        var parent = $("#"+button_id).parent();
        var remove_photo = $(parent).find('.remove_photo');
        var attachment_id_field = $(parent).find('input[name*=attachment_id]');
        var preview = $("#"+(preview_id));
        $(remove_photo).on('click', function(){
            $.post($(this).attr('href'), {'_method':'DELETE'}, function(){
                $(remove_photo).addClass('hidden');
                $(preview).attr('src', $("#"+(preview_id)).data('default-url'));
                $(attachment_id_field).val('');
            });
           return false;
        });

        new AjaxUpload(button_id || PhotoUpload.default_button_id, {
            responseType: 'json',
            action:url,
            data: {
                authenticity_token: $('input[name=authenticity_token]').val(),
                action : "update",
                _method : "put"
            },
            onSubmit : function() {
                $('.ajax-loader-indicator').removeClass('hide');
            },
            onComplete: function(file, response) {
                if (response.url) {
                    $(preview).attr('src', response.url + "?time=" + new Date().getTime());
                    $(attachment_id_field).val(response.attachment_id);
                    $(remove_photo).removeClass('hidden').attr('href', response.attachment_url);

                    if (typeof(onSuccess) == "function"){
                      onSuccess(response.attachment_id, response);
                    }
                } else if (response.error) {
                    alert('An error occurred while loading this picture. Please make sure that the picture format is .png, .jpg, or .gif and that the picture size is less than 2 MB.');
                }
                $('.ajax-loader-indicator').addClass('hide');
            }
        })
    }

};