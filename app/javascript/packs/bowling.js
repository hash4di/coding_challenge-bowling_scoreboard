$(function(){
  current_game_id = null;

  $("#new-game-but").on('click', function(){
    $.post("/games", {})
      .done(function(data){
        update_current_game_id(data.id);
        update_score();
        clear_error_message();
        console.log("Success on requesting POST '/games'. Created game with id: " + data.id);
      })
      .fail(function(data){
        console.error("Error on requesting POST '/games'.");
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
    $.get("/games/" + current_game_id)
      .done(function(data){
        console.log("Success on requesting GET '/games/" + current_game_id);
        $("#game-score").text(data.score);
        $("#game-frames").text(data.frame_number);
        $("#game-over").text(data.game_finished);
      })
      .fail(function(data){
        console.error("Error on requesting GET '/games/" + current_game_id);
        console.error(data);
      })
  }

  function send_knocked_pins(knocked_pins){
    $.ajax({
        "url": "/games/"+current_game_id,
        "type": "PUT",
        "data": {"knocked_pins": knocked_pins},
        done: function (data, text) {
          update_score();
          clear_error_message();
          console.log("Success on requesting PUT '/games/" + current_game_id + " with body: {knocked_pins: " + knocked_pins + "}");
          $("#knocked-pins").val("");
        },
        fail: function (request, status, error) {
          try {
            error_message = request.responseJSON.message;
          }
          catch(err) {
            error_message = "";
          }
          finally {
            update_error_message(error_message);
            console.error("Error on requesting PUT '/games/" + current_game_id + " with body: {knocked_pins: " + knocked_pins + "}");
            console.error(request);
          }
        }
    });
  }

  function update_error_message(message){
    if (!message) { message = "Server error." }
    $("#error-message").text(message);
  }

  function clear_error_message(){
    $("#error-message").text("");
  }
})