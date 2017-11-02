
_ = require 'underscore'
path = require 'path'
React = require 'react'
{RetinaImg} = require 'nylas-component-kit'
icsParser = require './ics-parser'
{Actions,
 DateUtils,
 Message,
 Event,
 ComponentRegistry,
 EventRSVPTask,
 DatabaseStore,
 AccountStore} = require 'nylas-exports'
moment = require 'moment-timezone'

class EventHeader extends React.Component
  @displayName: 'EventHeader'

  @propTypes:
    message: React.PropTypes.instanceOf(Message).isRequired

  constructor: (@props) ->
    if this.props.message.events.length > 12
      eventContent = icsParser.convert( @props.message.events );
    else 
      return null;
    @state =
      event: eventContent
    
    @isEventValid = typeof eventContent == "object";
    calendarObj = @state.event.VCALENDAR[0];
    
    @eventDetails = {
      "title": calendarObj.VEVENT.SUMMARY,
      "start_time": moment(calendarObj.VEVENT.DTSTART + calendarObj.VTIMEZONE.DAYLIGHT.TZOFFSETTO).tz(DateUtils.timeZone),
      "end_time": moment(calendarObj.VEVENT.DTEND + calendarObj.VTIMEZONE.DAYLIGHT.TZOFFSETTO).tz(DateUtils.timeZone),
      "location": calendarObj.VEVENT.LOCATION,
      "description": calendarObj.VEVENT.DESCRIPTION,
      "status": calendarObj.VEVENT.STATUS
    }

  _onChange: =>
    # TODO
    return

  componentDidMount: =>
    # TODO: This should use observables!
    return

  componentWillReceiveProps: (nextProps) =>
    # TODO
    return

  componentWillUnmount: =>
    #TODO
    return

  render: =>
    timeFormat = DateUtils.getTimeFormat({timeZone: true})
    if @isEventValid?
      <div className="event-wrapper">
        <div className="event-header">
          <RetinaImg name="icon-RSVP-calendar-mini@2x.png"
                     mode={RetinaImg.Mode.ContentPreserve}/>
          <span className="event-title-text">Event: </span><span className="event-title">{@eventDetails.title}</span>
        </div>
        <div className="event-body">
          <div className="event-date">
            <div className="event-day">
              {@eventDetails.start_time.format("dddd, MMMM Do")}
            </div>
            <div>
              <div className="event-time">
                {@eventDetails.start_time.format("h:mm a") + " - " + @eventDetails.end_time.format("h:mm a")}
              </div>
              <div className="event-description">
                {@eventDetails.description}
              </div>
              {@_renderEventActions()}
            </div>
          </div>
        </div>
      </div>
    else
      <div></div>

  _renderEventActions: =>
    # TODO Later
    return

  _rsvp: (status) =>
    # TODO Later
    return

module.exports = EventHeader
