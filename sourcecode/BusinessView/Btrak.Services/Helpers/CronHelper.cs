using Btrak.Models;
using Cronos;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Helpers
{
    public class CronHelper
    {
        public static List<CronDecryptModel> GenerateDates(string cronExpression, DateTime startDate, DateTime endDate, int spanInYears, int spanInMonths, int spanInDays)
        {
            List<CronDecryptModel> generatedDates = new List<CronDecryptModel>();
            CronExpression expression = CronExpression.Parse(cronExpression);

            var occurrences = expression.GetOccurrences(startDate.ToUniversalTime(), endDate.ToUniversalTime()).ToList();

            for (var i = 0; i < occurrences.Count; i++)
            {
                generatedDates.Add(new CronDecryptModel
                {
                    StartTime = new DateTime(occurrences[i].Year, occurrences[i].Month, occurrences[i].Day, occurrences[i].Hour, occurrences[i].Minute, occurrences[i].Second),
                    EndTime = getEndDate(occurrences[i], spanInYears, spanInMonths, spanInDays)
                });
            }
            return generatedDates;
        }

        static DateTime getEndDate(DateTime occurrence, int spanInYears, int spanInMonths, int spanInDays)
        {
            TimeSpan ts = new TimeSpan(23, 59, 59);
            DateTime retDate = new DateTime(occurrence.Year, occurrence.Month, occurrence.Day, ts.Hours, ts.Minutes, ts.Seconds);
            if (spanInYears > 0)
            {
                retDate = new DateTime(retDate.Year, 12, 31, ts.Hours, ts.Minutes, ts.Seconds);
                retDate = retDate.AddYears((spanInYears - 1));
            }
            if (spanInMonths > 0)
            {
                int lastday = DateTime.DaysInMonth(retDate.Year, retDate.Month);
                retDate = new DateTime(retDate.Year, retDate.Month, lastday, ts.Hours, ts.Minutes, ts.Seconds);
                retDate = retDate.AddMonths(spanInMonths - 1);
            }
            if (spanInDays > 0)
            {
                retDate = retDate.AddDays(spanInDays - 1);
            }
            return retDate;
        }
    }
}
