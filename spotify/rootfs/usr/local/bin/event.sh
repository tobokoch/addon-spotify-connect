case ${PLAYER_EVENT} in

changed | started | playing | preloading)
  STATE="playing"
  ;;

stopped)
  STATE="idle"
  ;;

paused)
  STATE="paused"
  ;;

volume_set) ;;

*) ;;

esac

if [ -n "${STATE}" ]; then
  curl -s \
    -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -H "Content-Type: application/json" \
    -XPOST \
    http://supervisor/core/api/states/media_player.spotify_addon \
    -d "{\"state\":\"${STATE}\",\"attributes\":{\"track_id\":\"${TRACK_ID}\",\"timestamp\":\"$(date +%s)\"}}"
fi
