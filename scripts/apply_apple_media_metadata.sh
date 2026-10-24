#!/usr/bin/env bash
# Write capture date, timezone and GPS from data.csv into each photo/video.
#
# Usage: ./apply_csv_metadata.sh [--apply] [--csv PATH]
#   Dry run by default (prints what would change). Pass --apply to write.
#   CSV defaults to ./data.csv. Paths in the CSV (directory/filename) are
#   resolved relative to the current directory.
#
# Expected CSV columns (pipe-delimited, with a header row):
#   asset_id|directory|filename|media_type|created_date|tz_name|latitude|longitude
#
# Requires exiftool (brew install exiftool). When applying, exiftool keeps a
# "<file>_original" backup of each changed file. Remove them later with:
#   exiftool -r -delete_original! .

set -uo pipefail

APPLY=0
CSV="data.csv"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1 ;;
    --csv)   CSV="$2"; shift ;;
    *)       echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

command -v exiftool >/dev/null || { echo "exiftool not found (brew install exiftool)" >&2; exit 1; }
[[ -f "$CSV" ]] || { echo "CSV not found: $CSV" >&2; exit 1; }

RED=$'\e[31m'; RESET=$'\e[0m'
[[ -t 1 ]] || { RED=''; RESET=''; }

ok=0; problems=0
problem() { echo "${RED}$1${RESET}"; problems=$((problems + 1)); }

# UTC offset (e.g. "-0400") of an IANA zone at a given local date/time.
# DST is handled because the offset is looked up for that specific date.
# Uses GNU date on Linux and BSD date on macOS.
iana_offset() {
  if date --version >/dev/null 2>&1; then
    TZ="$1" date -d "${2:0:10} ${2:11:8}" +%z
  else
    TZ="$1" date -j -f '%Y-%m-%dT%H:%M:%S' "${2:0:19}" +%z
  fi 2>/dev/null
}

# Turn the CSV's timezone info into an EXIF offset like "-04:00".
# Accepts an offset at the end of created_date (...T17:17:54-04:00 or ...Z),
# a tz_name such as "GMT-0400", "UTC+05:30" or "GMT", or an IANA zone name
# such as "America/New_York". Prints nothing if unknown.
offset_for() {
  local date="$1" tz="${2// /}"
  if [[ "${date:19}" =~ ([+-][0-9]{2}):?([0-9]{2})$ ]]; then
    echo "${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"; return
  fi
  [[ "${date:19}" == *Z || "$tz" == "GMT" || "$tz" == "UTC" ]] && { echo "+00:00"; return; }
  # IANA names: only trust ones that exist, since `date` silently falls back
  # to UTC for unknown zones
  if [[ "$tz" == */* && -f "/usr/share/zoneinfo/$tz" ]]; then
    tz="$(iana_offset "$tz" "$date")"
  fi
  tz="${tz#GMT}"; tz="${tz#UTC}"
  if [[ "$tz" =~ ^([+-][0-9]{2}):?([0-9]{2})$ ]]; then
    echo "${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
  fi
}

(( APPLY )) && echo "Applying changes..." || echo "DRY RUN: nothing will be written (use --apply)."
echo

# Skip the header row, strip Windows line endings, then read each row.
while IFS='|' read -r _id dir file _type created tz lat lon; do
  path="$dir/$file"

  # --- Validate the row ----------------------------------------------------
  if [[ ! -f "$path" ]]; then
    problem "MISSING   $path"; continue
  fi
  if [[ ! "$created" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2} ]]; then
    problem "BAD DATE  $path  (\"$created\")"; continue
  fi

  # --- Build the values ----------------------------------------------------
  # created_date is local wall-clock time; EXIF wants "YYYY:MM:DD HH:MM:SS".
  dt="${created:0:4}:${created:5:2}:${created:8:2} ${created:11:8}"
  off="$(offset_for "$created" "$tz")"
  [[ -z "$off" ]] && problem "NO TZ     $path  (tz \"$tz\" not understood; date written without offset)"

  # Photos uses -180 to mean "no location"
  has_gps=0
  [[ -n "$lat" && -n "$lon" && "$lat" != "-180"* && "$lon" != "-180"* ]] && has_gps=1

  # --- exiftool arguments, which differ for videos and images --------------
  # -q -q: quiet; -P: keep the file's modified time;
  # -m: don't fail on "[minor]" errors (e.g. unparseable maker notes)
  args=(-q -q -P -m)
  case "$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')" in
    mov|mp4|m4v)
      # QuickTime dates are stored in UTC; QuickTimeUTC makes exiftool convert
      # from our local time + offset. Keys:CreationDate keeps the local offset.
      args+=(-api QuickTimeUTC
             "-QuickTime:CreateDate=$dt$off" "-QuickTime:ModifyDate=$dt$off"
             "-Keys:CreationDate=$dt$off")
      (( has_gps )) && args+=("-Keys:GPSCoordinates=$lat, $lon")
      ;;
    *)
      args+=("-DateTimeOriginal=$dt" "-CreateDate=$dt")
      [[ -n "$off" ]] && args+=("-OffsetTimeOriginal=$off" "-OffsetTimeDigitized=$off")
      # The trailing * also sets GPSLatitudeRef/GPSLongitudeRef from the sign
      (( has_gps )) && args+=("-GPSLatitude*=$lat" "-GPSLongitude*=$lon")
      ;;
  esac

  # --- Report, and write if --apply ----------------------------------------
  gps="no GPS"; (( has_gps )) && gps="GPS $lat, $lon"
  summary="$path  ->  $dt$off  |  $gps"

  if (( ! APPLY )); then
    echo "WOULD SET $summary"; ok=$((ok + 1))
  elif err="$(exiftool "${args[@]}" "$path" 2>&1)"; then
    echo "UPDATED   $summary"; ok=$((ok + 1))
  else
    problem "FAILED    $path  ($err)"
  fi
done < <(tail -n +2 "$CSV" | tr -d '\r')

echo
echo "Done: $ok ok, $problems problem(s)."
(( APPLY )) || echo "Dry run only. Re-run with --apply to write changes."
