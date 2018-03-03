http = require "lapis.nginx.http"

import decode from require "cjson"
import Videos, Playlists, PlaylistVideos from require "models"
import encode_query_string from require "lapis.util"
import locate, autoload from require "locator"
import settings from autoload "utility"
import shallow_copy from locate "gtable"
import insert from table
import date, time from os

query = {
  key: "AIzaSyA-IIG7fS3tH5mkHq5avueTdBq48HAOT5A"
  part: "snippet,contentDetails"
  maxResults: 50
}
channel_query = {
  channelId: "UCZZ-RBp_D-a-JIuKDykhegA"
}

time_for_db = (str) ->
  year, month, day, hour, min, sec = str\match "(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)"
  return date "!%Y-%m-%d %X", time :year, :month, :day, :hour, :min, :sec

get_thumbnail = (snippet) ->
  if snippet.thumbnails.maxres
    return snippet.thumbnails.maxres.url
  elseif snippet.thumbnails.high
    return snippet.thumbnails.high.url
  else
    return snippet.thumbnails.standard.url

uploads = (pageToken, maxResults) ->
  query_table = shallow_copy query, channel_query, :pageToken, fields: "items(contentDetails/upload,snippet(description,publishedAt,thumbnails(high/url,maxres/url,standard/url),title,type)),nextPageToken,prevPageToken"
  query_table.maxResults = maxResults if maxResults
  query_string = encode_query_string query_table
  body = http.simple "https://www.googleapis.com/youtube/v3/activities?#{query_string}"
  data = decode body

  videos = {}
  for activity in *data.items
    if activity.snippet.type == "upload"
      insert videos, Videos\create {
        id: activity.contentDetails.upload.videoId
        title: activity.snippet.title
        description: activity.snippet.description
        thumbnail: get_thumbnail activity.snippet
        published_at: time_for_db activity.snippet.publishedAt
      }

  -- if we were using the last stored pageToken, save next pageToken
  if pageToken == settings["youtube.next_uploads_pageToken"] and data.nextPageToken
    settings.set "youtube.next_uploads_pageToken", data.nextPageToken

  return videos

playlists = (pageToken, maxResults) ->
  query_table = shallow_copy query, channel_query, :pageToken, fields: "items(id,snippet(description,publishedAt,tags,thumbnails(high/url,maxres/url,standard/url),title)),nextPageToken,prevPageToken"
  query_table.part = "snippet"
  query_table.maxResults = maxResults if maxResults
  query_string = encode_query_string query_table
  body = http.simple "https://www.googleapis.com/youtube/v3/playlists?#{query_string}"
  data = decode body

  playlists = {}
  for playlist in *data.items
    insert playlists, Playlists\create {
      id: playlist.id
      title: playlist.snippet.title
      description: playlist.snippet.description
      thumbnail: get_thumbnail playlist.snippet
      published_at: time_for_db playlist.snippet.publishedAt
    }

  -- if we were using the last stored pageToken, save next pageToken
  if pageToken == settings["youtube.next_playlists_pageToken"] and data.nextPageToken
    settings.set "youtube.next_playlists_pageToken", data.nextPageToken

  return playlists

playlist_videos = (playlistId, pageToken, maxResults) ->
  query_table = shallow_copy query, :playlistId, :pageToken, fields: "items(contentDetails(endAt,startAt,videoId,videoPublishedAt),snippet(description,position,publishedAt,thumbnails(high/url,maxres/url,standard/url),title)),nextPageToken,prevPageToken"
  query_table.maxResults = maxResults if maxResults
  query_string = encode_query_string query_table
  body = http.simple "https://www.googleapis.com/youtube/v3/playlistItems?#{query_string}"
  data = decode body

  videos = {}
  for item in *data.items
    video = Videos\find id: item.contentDetails.videoId
    unless video
      video = Videos\create {
        id: item.contentDetails.videoId
        title: item.snippet.title
        description: item.snippet.description
        thumbnail: get_thumbnail item.snippet
        published_at: time_for_db item.contentDetails.videoPublishedAt
      }
    insert videos, video
    PlaylistVideos\create {
      playlist_id: playlistId
      video_id: video.id
      published_at: time_for_db item.snippet.publishedAt
    }

  -- if we were using the last stored pageToken, save next pageToken
  if pageToken == settings["youtube.next_playlist_pageToken.#{playlistId}"] and data.nextPageToken
    settings.set "youtube.next_playlist_pageToken.#{playlistId}", data.nextPageToken

  return videos

{
  :uploads
  :playlists
  :playlist_videos
}
