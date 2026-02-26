{
  config,
  lib,
  ...
}:
let
  calendars = [
    {
      name = "Personal";
      primary = true;
      type = "caldav";
      path = "personal";
      suppressAlarms = false;
      color = "#31CC7C";
    }
    {
      name = "Work";
      primary = false;
      type = "caldav";
      path = "work";
      suppressAlarms = false;
      color = "#C98879";
    }
    {
      name = "Lea";
      primary = false;
      type = "caldav";
      path = "lea";
      suppressAlarms = false;
      color = "#0082C9";
    }
    {
      name = "Festivals & Events";
      primary = false;
      type = "caldav";
      path = "festivals-events";
      suppressAlarms = false;
      color = "#B6469D";
    }
    {
      name = "Birthdays";
      primary = false;
      type = "caldav";
      path = "contact_birthdays";
      suppressAlarms = true;
      color = "#FFFFCA";
    }
  ];

  getCalendarUsername = _: "yeldir";
  getCalendarUrl =
    calendar: "https://nextcloud.yeldirium.de/remote.php/dav/calendars/yeldir/${calendar.path}/";
  makeNextcloudCalendar = calendar: {
    inherit (calendar) primary;

    remote = {
      inherit (calendar) type;
      userName = getCalendarUsername calendar;
      url = getCalendarUrl calendar;
    };

    thunderbird = lib.mkIf config.programs.thunderbird.enable {
      enable = true;

      inherit (calendar) color;

      # TODO: If at some point possible, set suppressAlarms here.
    };
  };
in
{
  accounts.calendar.accounts = lib.attrsets.mergeAttrsList (
    map (calendar: {
      "${calendar.name}" = makeNextcloudCalendar calendar;
    }) calendars
  );

  programs.thunderbird = lib.mkIf config.programs.thunderbird.enable {
    profiles."hannes.leutloff@yeldirium.de".calendarAccountsOrder = lib.map (
      calendar: calendar.name
    ) calendars;
  };
}
