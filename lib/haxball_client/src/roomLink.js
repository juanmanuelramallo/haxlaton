function handleRoomLink(roomLink) {
  if (roomLink) {
    let endpoint = process.env.BASE_API_URL + "/room";
    fetch(endpoint, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + process.env.CLIENT_TOKEN
      },
      body: JSON.stringify({room: {haxball_room_url: roomLink}}),
      redirect: "follow"
    }).then(response => response.json())
      .then(result => {
        console.log(result);
      })
      .catch(error => {
        console.error("Error sharing the Room Link with server", error);
      });
  } else {
    console.warn('Room link is not defined');
  }
}

export { handleRoomLink };
