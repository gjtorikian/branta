$(document).ready ->
  $(".add-hook-button").on "click", ->
    console.log $(this).attr('data-repo-name')
    $.ajax '/webhook/create',
      type: 'POST'
      data:
        name: $(this).attr('data-repo-name')
      error: (jqXHR, textStatus, errorThrown) ->
          $('body').append "AJAX Error: #{textStatus} #{errorThrown}"
      success: (data, textStatus, jqXHR) ->
          $('body').append "Successful AJAX call: #{data}"
