
using System;

namespace Btrak.Models
{
    public class Formatter
    {
        public string Format(DateTime formatterDate)
        {
            const int SECOND = 1;
            const int MINUTE = 60 * SECOND;
            const int HOUR = 60 * MINUTE;
            const int DAY = 24 * HOUR;
            const int MONTH = 30 * DAY;

            var ts = new TimeSpan(DateTime.Now.Ticks - formatterDate.Ticks);
            double delta = Math.Abs(ts.TotalSeconds);

            if (delta < 1 * MINUTE)
                return ts.Seconds == 1 ? "one second ago" : " just now";

            if (delta < 2 * MINUTE)
                return "a minute ago";

            if (delta < 45 * MINUTE)
                return ts.Minutes + " minutes ago";

            if (delta < 90 * MINUTE)
                return "an hour ago";

            if (delta < 24 * HOUR)
                return ts.Hours + " hours ago";

            if (delta < 48 * HOUR)
                return "yesterday";

            if (delta < 30 * DAY)
                return ts.Days + " days ago";

            if (delta < 12 * MONTH)
            {
                int months = Convert.ToInt32(Math.Floor((double)ts.Days / 30));
                return months <= 1 ? "one month ago" : months + " months ago";
            }
            else
            {
                int years = Convert.ToInt32(Math.Floor((double)ts.Days / 365));
                return years <= 1 ? "one year ago" : years + " years ago";
            }
        }
    }

    public class TimesheetFormatter
    {
        public string Format(DateTime formatterDate)
        {
            const int SECOND = 1;
            const int MINUTE = 60 * SECOND;
            const int HOUR = 60 * MINUTE;
            const int DAY = 24 * HOUR;
            const int MONTH = 30 * DAY;

            var ts = new TimeSpan(DateTime.UtcNow.Ticks - formatterDate.Ticks);
            double delta = Math.Abs(ts.TotalSeconds);

            if (delta < 1 * MINUTE)
                return ts.Seconds == 1 ? "one second ago" : " just now";

            if (delta < 2 * MINUTE)
                return "a minute ago";

            if (delta < 45 * MINUTE)
                return ts.Minutes + " minutes ago";

            if (delta < 90 * MINUTE)
                return "an hour ago";

            if (delta < 24 * HOUR)
                return ts.Hours + " hours ago";

            if (delta < 48 * HOUR)
                return "yesterday";

            if (delta < 30 * DAY)
                return ts.Days + " days ago";

            if (delta < 12 * MONTH)
            {
                int months = Convert.ToInt32(Math.Floor((double)ts.Days / 30));
                return months <= 1 ? "one month ago" : months + " months ago";
            }
            else
            {
                int years = Convert.ToInt32(Math.Floor((double)ts.Days / 365));
                return years <= 1 ? "one year ago" : years + " years ago";
            }
        }
    }

    public class DateTimeFormatter
    {
        public static string GetTimeAgo(DateTime? dateTime, string format = "dd-MM-yyyy HH:mm:ss")
        {
            const int second = 1;
            const int minute = 60 * second;
            const int hour = 60 * minute;

            var dateTimeStr = string.Empty;
            if (dateTime != null)
            {
                var ts = new TimeSpan(DateTime.Now.Ticks - dateTime.Value.Ticks);
                double delta = Math.Abs(ts.TotalSeconds);

                     if (delta  < 1 * minute)
                    dateTimeStr = ts.Seconds <= 1 ?  "just now" : ts.Seconds + "s ago";

                else if (delta  < 60 * minute)
                    dateTimeStr = ts.Minutes + "m ago";

                else if (delta  < 12 * hour)
                    dateTimeStr = ts.Hours + "h ago";
                else
                    dateTimeStr = dateTime.Value.ToString(format);
            }

            return dateTimeStr;
        } // GetTimeAgo
    } // class: DateTimeFormatter
}
