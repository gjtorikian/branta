ready = ->

  $('.webhook-button').on "click", ->
    el = $(this)
    if el.hasClass('add-hook-button')
      $.ajax '/webhook/create',
        type: 'POST'
        data:
          name: el.attr('data-repo-name')
        error: (jqXHR, textStatus, errorThrown) ->
          $('body').append "AJAX Error: #{textStatus} #{errorThrown}"
        success: (data, textStatus, jqXHR) =>
          el.toggleClass( "remove-hook-button" ).toggleClass( "add-hook-button" )
          el.html('<span class="octicon octicon-x"></span> Remove it, please!')
    else
      $.ajax '/webhook/delete',
        type: 'DELETE'
        data:
          name: el.attr('data-repo-name')
        error: (jqXHR, textStatus, errorThrown) ->
          $('body').append "AJAX Error: #{textStatus} #{errorThrown}"
        success: (data, textStatus, jqXHR) =>
          el.toggleClass( "add-hook-button" ).toggleClass( "remove-hook-button" )
          el.html('<span class="octicon octicon-zap"></span> Let\'s do this!')

$(document).ready(ready)
$(document).on('page:load', ready)
