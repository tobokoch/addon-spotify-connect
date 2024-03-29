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

sink)
  STATE="sink"
  ;;

volume_set) ;;

*) ;;

esac

if [ -n "${STATE}" ]; then
  TIMESTAMP=$(date +%s)

  if [ -n "${SINK_STATUS}" ]; then

    curl -s \
      -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
      -H "Content-Type: application/json" \
      -XPOST http://supervisor/core/api/states/media_player.spotify_addon_sink_state \
      -d "{\"state\":\"${SINK_STATUS}\"}"

  else

    curl -s \
      -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
      -H "Content-Type: application/json" \
      -XPOST http://supervisor/core/api/states/media_player.spotify_addon \
      -d "{\"state\":\"${STATE}\",\"attributes\":{\"track_id\":\"${TRACK_ID}\",\"timestamp\":\"${TIMESTAMP}\"}}"

  fi

  if [ -n "${OLD_TRACK_ID}" ]; then

    curl -s \
      -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
      -H "Content-Type: application/json" \
      -XPOST http://supervisor/core/api/states/media_player.spotify_addon_old_track_id \
      -d "{\"state\":\"${OLD_TRACK_ID}\"}"

  fi
fi
