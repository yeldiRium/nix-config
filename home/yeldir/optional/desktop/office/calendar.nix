{
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
    }
    {
      name = "Work";
      primary = false;
      type = "caldav";
      path = "work";
      suppressAlarms = false;
    }
    {
      name = "Lea";
      primary = false;
      type = "caldav";
      path = "lea";
      suppressAlarms = false;
    }
    {
      name = "Festivals & Events";
      primary = false;
      type = "caldav";
      path = "festivals-events";
      suppressAlarms = false;
    }
    {
      name = "Birthdays";
      primary = false;
      type = "caldav";
      path = "contact_birthdays";
      suppressAlarms = true;
    }
  ];

  getCalendarUsername = _: "yeldir";
  getCalendarUrl =
    calendar: "https://nextcloud.yeldirium.de/remote.php/dav/calendars/yeldir/${calendar.path}/";
in
{
  accounts.calendar.accounts =
    let
      makeNextcloudCalendar = calendar: {
        inherit (calendar) primary;
        remote = {
          inherit (calendar) type;
          userName = getCalendarUsername calendar;
          url = getCalendarUrl calendar;
        };
      };
    in
    lib.attrsets.mergeAttrsList (
      map (calendar: {
        "${calendar.name}" = makeNextcloudCalendar calendar;
      }) calendars
    );

  # TODO: Replace this once HomeManager 25.11 is released and
  # config.accounts.calendar.accounts.<name>.thunderbird.enable is available.
  # Make sure it works, though, including the order of calendars.
  programs.thunderbird.settings =
    let
      safeName = builtins.replaceStrings [ "." ] [ "-" ];
      makeThunderbirdCalendar =
        calendar:
        let
          calendarAccountSafeName = safeName calendar.name;
        in
        {
          "calendar.registry.${calendarAccountSafeName}.cache.enabled" = true;
          "calendar.registry.${calendarAccountSafeName}.calendar-main-default" = calendar.primary;
          "calendar.registry.${calendarAccountSafeName}.calendar-main-in-composite" = true;
          "calendar.registry.${calendarAccountSafeName}.name" = calendar.name;
          "calendar.registry.${calendarAccountSafeName}.type" = calendar.type;
          "calendar.registry.${calendarAccountSafeName}.uri" = getCalendarUrl calendar;
          "calendar.registry.${calendarAccountSafeName}.username" = getCalendarUsername calendar;
          "calendar.registry.${calendarAccountSafeName}.suppressAlarms" = calendar.suppressAlarms;
        };
    in
    lib.attrsets.mergeAttrsList (map makeThunderbirdCalendar calendars)
    // {
      "calendar.list.sortOrder" = lib.fold (cal: acc: cal.name + " " + acc) "" calendars;

      # Keep these after removing the above.
      "calendar.week.start" = 1;
    };
}
