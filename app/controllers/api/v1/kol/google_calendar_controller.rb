require 'google/apis/calendar_v3'
require 'signet/oauth_2/client'

class Api::V1::Kol::GoogleCalendarController < ApplicationController
  around_action :calendar_authorization, only: %i[index create show update destroy]

  def check_integrate
    @integrate = current_user.profile.google_integrate
    if @integrate.nil? || @integrate&.code_authorization.nil?
      render json: { message: 'Not Integrate' }, status: 400
    else
      render json: { message: 'Interage' }, status: 200
    end
  end

  def index
    today = DateTime.now
    first_day_of_month = today.beginning_of_month
    last_day_of_month = today.end_of_month
    time_min = first_day_of_month.rfc3339
    time_max = last_day_of_month.rfc3339
    events = @calendar.list_events('primary', max_results: 250, time_zone: 'Asia/Ho_Chi_Minh', time_min:, time_max:)
    render json: events, status: 200
  end

  def create
    new_event = Google::Apis::CalendarV3::Event.new
    new_event.summary = params[:event][:title]
    new_event.description = params[:event][:description]
    new_event.start = Google::Apis::CalendarV3::EventDateTime.new(date_time: DateTime.parse(params[:event][:start_time]).rfc3339)
    new_event.end = Google::Apis::CalendarV3::EventDateTime.new(date_time: DateTime.parse(params[:event][:end_time]).rfc3339)
    created_event = @calendar.insert_event('primary', new_event)
    render json: created_event, status: 200
  end

  def show
    event = @calendar.get_event('primary', params[:id])
    render json: event, status: 200
  end

  def update
    event = @calendar.get_event('primary', params[:id])
    event.summary = params[:event][:title]
    event.description = params[:event][:description]
    event.start = Google::Apis::CalendarV3::EventDateTime.new(date_time: DateTime.parse(params[:event][:start_time]).rfc3339)
    event.end = Google::Apis::CalendarV3::EventDateTime.new(date_time: DateTime.parse(params[:event][:end_time]).rfc3339)
    updated_event = @calendar.update_event('primary', params[:id], event)
    render json: updated_event, status: 200
  end

  def destroy
    @calendar.delete_event('primary', params[:id])
    render json: { message: 'Successfully deleted event' }, status: 200
  end

  private

  def calendar_authorization
    @integrate = current_user.profile.google_integrate
    @authorization = Signet::OAuth2::Client.new(
      access_token: @integrate.access_token,
      refresh_token: @integrate.refresh_token,
      client_id: Rails.application.credentials.google_id,
      client_secret: Rails.application.credentials.google_key,
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
    )
    begin
      @calendar = Google::Apis::CalendarV3::CalendarService.new
      @calendar.authorization = @authorization
      yield
    rescue Google::Apis::AuthorizationError => e
      if e.status_code == 401
        begin
          @authorization.fetch_access_token!
          new_access_token = @authorization.access_token
          @integrate.update(access_token: new_access_token)
          retry
        rescue StandardError
          @integrate.update(access_token: nil, refresh_token: nil, code: nil)
          render status: 401
        end
      end
    end
  end
end
