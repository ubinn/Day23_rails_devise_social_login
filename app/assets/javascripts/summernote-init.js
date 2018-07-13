$(document).on('ready', function() {
    function sendFile(file, toSummernote) {
      var data = new FormData;
      data.append('upload[image]', file);
      $.ajax({
        data: data,
        type: 'POST',
        url: '/uploads',
        cache: false,
        contentType: false,
        processData: false,
        success: function(data) {
          console.log('file uploading...');
          console.dir(data);
          return toSummernote.summernote("insertImage", data.image_path.url);
        }
      });
    };
    
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      height: 300,
      callbacks: {
        onImageUpload: function(files) {    // 이미지를 슥 해서 슥 넣으면 발생 + 이미지 업로드 해도 발생
          return sendFile(files[0], $(this));
        }
      }
    });
  });
});