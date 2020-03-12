$(function(){
  api_url_path = "/api/v1/games/"
  current_game_id = null;

  $("#new-game-but").on('click', function(){
    $.post(api_url_path, {})
      .done(function(data){
        update_current_game_id(data.id);
        update_score();
        clear_error_message();
        console.log("Success on requesting POST '"+ api_url_path + "'. Created game with id: " + data.id);
      })
      .fail(function(data){
        console.error("Error on requesting POST '"+ api_url_path + "'.");
        console.error(data);
      })
  })

  $("#knocked-pins-form").on("submit", function(e){
    e.preventDefault();
    knocked_pins = $("#knocked-pins").val();
    send_knocked_pins(knocked_pins);
  })

  setInterval(function(){
    if (current_game_id) { update_score() }
  }, 2000);


  function update_current_game_id(id){
    current_game_id = id;
    $("#game-id").text(id);
  }

  function update_score(){
    $.get(api_url_path + current_game_id)
      .done(function(data){
        console.log("Success on requesting GET '"+ api_url_path + current_game_id + "'");
        $("#game-score").text(data.score);
        $("#game-score-by-frame").text(JSON.stringify(data.score_by_frame)); //@WIP: implement working solution for frames with score.
        $("#game-frames").text(data.score_by_frame.length); //@WIP: find solution for not passing unidentify.
        $("#game-finished").text(data.game_finished.toString()); //@WIP: implement working solution with game status.
      })
      .fail(function(data){
        console.error("Error on requesting GET '"+ api_url_path + current_game_id);
        console.error(data);
      })
  }

  function send_knocked_pins(knocked_pins){
    $.ajax({
        "url": api_url_path + current_game_id,
        "type": "PUT",
        "data": {"knocked_pins": knocked_pins},
        done: function (data, text) {
          update_score();
          clear_error_message();
          console.log("Success on requesting PUT '"+ api_url_path + current_game_id + "' with body: {knocked_pins: " + knocked_pins + "}");
          $("#knocked-pins").val("");
        },
        error: function (request, status, error) {
          try {
            error_message = request.responseJSON.message;
          }
          catch(err) {
            error_message = "";
          }
          finally {
            update_error_message(error_message);
            console.error("Error on requesting PUT '"+ api_url_path + current_game_id + "' with body: {knocked_pins: " + knocked_pins + "}");
            console.error(request);
          }
        }
    });
  }

  function update_error_message(message){
    if (!message) { message = "Wrong Pins format. Please use only numbers in the range 1 - 10." }
    $("#error-message").text(message);
  }

  function clear_error_message(){
    $("#error-message").text("");
  }
})