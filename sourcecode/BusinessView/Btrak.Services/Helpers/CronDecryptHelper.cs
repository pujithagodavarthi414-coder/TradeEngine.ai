using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers
{
    public class CronDecryptHelper
    {
        public static List<CronDecryptModel> GenerateDates(string expression, DateTime startDate, DateTime endDate)
        {
            List<CronDecryptModel> generatedDates = new List<CronDecryptModel>();

            string[] splitExpression = expression.Split(' ');
            CronDecryptHelper cronDecryptHelper = new CronDecryptHelper(); 
            if (splitExpression.Length == 7)
            {
                // for Year
                List<int> years = cronDecryptHelper.getListOfYears(splitExpression[6], startDate, endDate);
                List<CronDecryptModel> months = cronDecryptHelper.getListOfMonths(splitExpression[4], startDate, endDate, years);
                List<CronDecryptModel> weekDays = cronDecryptHelper.getWeekWiseDates(splitExpression[5], startDate, endDate, months);
                List<CronDecryptModel> withDays = cronDecryptHelper.getDayWiseDates(splitExpression[3], startDate, endDate, weekDays);
                List<CronDecryptModel> withHours = cronDecryptHelper.getHourWiseDates(splitExpression[2], startDate, endDate, withDays);
                List<CronDecryptModel> withMinutes = cronDecryptHelper.getMinuteWiseDates(splitExpression[1], startDate, endDate, withHours);
                List<CronDecryptModel> withSeconds = cronDecryptHelper.getSecondWiseDates(splitExpression[0], startDate, endDate, withMinutes);

                return withSeconds;
            }

            if (splitExpression.Length == 5)
            {
                // for Year
                List<int> years = cronDecryptHelper.getListOfYears("*", startDate, endDate);
                List<CronDecryptModel> months = cronDecryptHelper.getListOfMonths(splitExpression[3], startDate, endDate, years);
                List<CronDecryptModel> weekDays = cronDecryptHelper.getWeekWiseDates(splitExpression[4], startDate, endDate, months);
                List<CronDecryptModel> withDays = cronDecryptHelper.getDayWiseDates(splitExpression[2], startDate, endDate, weekDays);
                List<CronDecryptModel> withHours = cronDecryptHelper.getHourWiseDates(splitExpression[1], startDate, endDate, withDays);
                List<CronDecryptModel> withMinutes = cronDecryptHelper.getMinuteWiseDates(splitExpression[0], startDate, endDate, withHours);
                //List<CronDecryptModel> withSeconds = getSecondWiseDates(splitExpression[0], startDate, endDate, withMinutes);

                return withMinutes;
            }
            return generatedDates;
        }

        public List<int> getListOfYears(string yearExpression, DateTime startDate, DateTime endDate)
        {
            List<int> years = new List<int>();
            if (yearExpression == "*")
            {
                int year = startDate.Year;
                int lastYear = endDate.Year;
                while (year <= lastYear)
                {
                    years.Add(year);
                    year++;
                }
            }
            else if (yearExpression.Contains("/"))
            {
                string[] repeatYears = yearExpression.Split('/');
                int fromyear = Convert.ToInt32(repeatYears[0]);
                int reapeatafter = Convert.ToInt32(repeatYears[1]);
                int repeater = 1;
                while (fromyear <= endDate.Year)
                {
                    if (repeater == reapeatafter)
                    {
                        years.Add(fromyear);
                    }
                    fromyear++;
                }
            }
            else if (yearExpression.Contains(","))
            {
                IEnumerable<int> repeatYears = yearExpression.Split(',').Select(x => Convert.ToInt32(x)).Where(x => x <= startDate.Year).AsEnumerable();
                years.AddRange(repeatYears);
            }
            return years;
        }

        public List<CronDecryptModel> getListOfMonths(string monthExpression, DateTime startDate, DateTime endDate, List<int> years)
        {
            List<CronDecryptModel> months = new List<CronDecryptModel>();
            CronDecryptModel monthModel;
            int month;
            if (monthExpression == "*")
            {
                DateTime monthWithDate;

                month = startDate.Month;
                foreach (int year in years)
                {
                    monthWithDate = new DateTime(year, month, 1);
                    while (monthWithDate.Year <= year && monthWithDate <= endDate)
                    {
                        monthModel = new CronDecryptModel();
                        monthModel.StartTime = monthWithDate;
                        monthModel.EndTime = monthWithDate.AddMonths(1).AddSeconds(-1);
                        months.Add(monthModel);
                        monthWithDate = monthWithDate.AddMonths(1);
                        month++;
                    }
                    month = 1;
                }
            }
            else if (monthExpression.Contains("/"))
            {
                string[] repeatMonths = monthExpression.Split('/');
                int fromMonth = Convert.ToInt32(repeatMonths[0]);
                int reapeatafter = Convert.ToInt32(repeatMonths[1]);
                DateTime monthWithDate;
                foreach (int year in years)
                {
                    int repeater = 1;
                    while (repeater <= 12)
                    {

                        monthWithDate = new DateTime(year, repeater, 1);
                        if (monthWithDate > endDate)
                            break;
                        monthModel = new CronDecryptModel();
                        monthModel.StartTime = monthWithDate;
                        monthModel.EndTime = monthWithDate.AddMonths(1).AddSeconds(-1);
                        months.Add(monthModel);
                        repeater = repeater + reapeatafter;
                    }
                }
            }
            else if (monthExpression.Contains(","))
            {
                string[] repeatMonths = monthExpression.Split(',');

                foreach (int year in years)
                {
                    //int monthNumber = 1;
                    for (int monthNumber = 1; monthNumber <= 12; monthNumber++)
                    {
                        string monthName = new DateTimeFormatInfo().GetMonthName(monthNumber).Substring(0, 3).ToUpper();
                        if (repeatMonths.Where(x => x == monthName).Any())
                        {
                            DateTime monthWithDate = new DateTime(year, monthNumber, 1);
                            if (monthWithDate > endDate)
                                break;
                            monthModel = new CronDecryptModel();
                            monthModel.StartTime = monthWithDate;
                            monthModel.EndTime = monthWithDate.AddMonths(1).AddSeconds(-1);
                            months.Add(monthModel);
                        }
                    }
                }
            }
            else if (monthExpression.Contains("-"))
            {
                string[] repeatMonths = monthExpression.Split('-');

                foreach (int year in years)
                {
                    bool ismonthValid = false;
                    for (int monthNumber = 1; monthNumber <= 12; monthNumber++)
                    {
                        string monthName = new DateTimeFormatInfo().GetMonthName(monthNumber).Substring(0, 3).ToUpper();
                        if (repeatMonths[0] == monthName)
                        {
                            ismonthValid = true;
                        }
                        DateTime monthWithDate = new DateTime(year, monthNumber, 1);
                        if (monthWithDate > endDate)
                            break;
                        monthModel = new CronDecryptModel();
                        monthModel.StartTime = monthWithDate;
                        monthModel.EndTime = monthWithDate.AddMonths(1).AddSeconds(-1);
                        months.Add(monthModel);

                        if (repeatMonths[1] == monthName)
                        {
                            ismonthValid = false;
                            break;
                        }
                    }
                }
            }
            else if (Int32.TryParse(monthExpression, out month))
            {
                DateTime monthWithDate;

                foreach (int year in years)
                {
                    monthWithDate = new DateTime(year, month, 1);
                    if (monthWithDate > endDate)
                        break;
                    monthModel = new CronDecryptModel();
                    monthModel.StartTime = monthWithDate;
                    monthModel.EndTime = monthWithDate.AddMonths(1).AddSeconds(-1);
                    months.Add(monthModel);
                }
            }
            return months;
        }

        public List<CronDecryptModel> getWeekWiseDates(string weekExpression, DateTime startDate, DateTime endDate, List<CronDecryptModel> monthDates)
        {
            List<string> weeks = new List<string> { "MON", "TUE", "WEB", "THU", "FRI", "SAT" };
            List<CronDecryptModel> weekDays = new List<CronDecryptModel>();
            CronDecryptModel weekModel;
            if (weekExpression == "?")
            {
                return monthDates;
            }
            if (weekExpression == "*")
            {
                foreach (CronDecryptModel monthDate in monthDates)
                {
                    int month = monthDate.StartTime.Month;
                    DateTime weekday = monthDate.StartTime;

                    while (weekday.Month == month && weekday <= endDate)
                    {
                        weekModel = new CronDecryptModel();
                        weekModel.StartTime = weekday;
                        weekday = weekday.AddDays(1);
                        weekModel.EndTime = weekday.AddSeconds(-1);
                        weekDays.Add(weekModel);
                    }
                }
            }
            else if (weekExpression == "/")
            {
                string[] repeatDays = weekExpression.Split('/');
                int repeatEvery = Convert.ToInt32(repeatDays[0]);
                int startFrom = Convert.ToInt32(repeatDays[1]);
                foreach (CronDecryptModel monthDate in monthDates)
                {
                    int month = monthDate.StartTime.Month;
                    DateTime weekday = monthDate.StartTime;
                    while (Convert.ToInt32(weekday.DayOfWeek) < startFrom)
                    {
                        weekday = weekday.AddDays(1);
                    }
                    while (weekday.Month == month)
                    {
                        if (weekday > endDate)
                            break;
                        weekModel = new CronDecryptModel();
                        weekModel.StartTime = weekday;
                        weekday = weekday.AddDays(repeatEvery);
                        weekModel.EndTime = weekday.AddSeconds(-1);
                        weekDays.Add(weekModel);
                    }
                }
            }
            else if (weekExpression.Contains(",") || weeks.Any(x => x == weekExpression))
            {
                string[] repeatWeeks = weekExpression.Split(',');

                foreach (CronDecryptModel monthDate in monthDates)
                {
                    int month = monthDate.StartTime.Month;
                    DateTime weekday = monthDate.StartTime;

                    while (weekday.Month == month)
                    {
                        string weekName = weekday.DayOfWeek.ToString().Substring(0, 3).ToUpper();
                        if (repeatWeeks.Where(x => x == weekName).Any())
                        {
                            if (weekday > endDate)
                                break;
                            weekModel = new CronDecryptModel();
                            weekModel.StartTime = weekday;
                            weekModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                            weekDays.Add(weekModel);
                        }
                        weekday = weekday.AddDays(1);
                    }
                }
            }
            else if (weekExpression.Contains("L"))
            {
                int lastDay = Convert.ToInt32(weekExpression.Substring(0, 1));

                foreach (CronDecryptModel monthDate in monthDates)
                {
                    int month = monthDate.StartTime.Month;
                    DateTime weekday = monthDate.StartTime;
                    weekday = weekday.AddMonths(1);
                    weekday = weekday.AddDays(-1);
                    while (Convert.ToInt32(weekday.DayOfWeek) + 1 == lastDay)
                    {
                        if (weekday > endDate)
                            break;
                        weekModel = new CronDecryptModel();
                        weekModel.StartTime = weekday;
                        weekModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                        weekDays.Add(weekModel);
                        break;
                    }
                }
            }
            else if (weekExpression.Contains('#'))
            {
                string[] repeatWeek = weekExpression.Split('#');

                int dayNumber;
                int dayOn = Convert.ToInt32(repeatWeek[1]);
                if (Int32.TryParse(repeatWeek[0], out dayNumber))
                {
                    foreach (CronDecryptModel monthDate in monthDates)
                    {
                        int month = monthDate.StartTime.Month;
                        DateTime weekday = monthDate.StartTime;
                        weekday = weekday.AddDays((dayOn - 1) * 7);
                        while (weekday.Month == month)
                        {
                            if (Convert.ToInt32(weekday.DayOfWeek) + 1 == dayNumber)
                            {
                                if (weekday > endDate)
                                    break;
                                weekModel = new CronDecryptModel();
                                weekModel.StartTime = weekday;
                                weekModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                                weekDays.Add(weekModel);
                                break;
                            }
                            weekday = weekday.AddDays(1);
                        }
                    }
                }
                else
                {
                    string weekName = repeatWeek[0];
                    foreach (CronDecryptModel monthDate in monthDates)
                    {
                        int month = monthDate.StartTime.Month;
                        DateTime weekday = monthDate.StartTime;
                        weekday = weekday.AddDays((dayOn - 1) * 7);

                        while (weekday.Month == month)
                        {
                            if (weekday.DayOfWeek.ToString().Substring(0, 3).ToUpper() == weekName)
                            {
                                if (weekday > endDate)
                                    break;
                                weekModel = new CronDecryptModel();
                                weekModel.StartTime = weekday;
                                weekModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                                weekDays.Add(weekModel);
                                break;
                            }
                            weekday = weekday.AddDays(1);
                        }
                    }
                }
            }
            return weekDays;
        }

        public List<CronDecryptModel> getDayWiseDates(string weekExpression, DateTime startDate, DateTime endDate, List<CronDecryptModel> weekDates)
        {
            List<CronDecryptModel> days = new List<CronDecryptModel>();
            CronDecryptModel dayModel;
            int day;
            if (weekExpression == "?")
            {
                return weekDates;
            }
            else if (weekExpression.Contains("/"))
            {
                string[] repeatDays = weekExpression.Split('/');
                int repeatEvery = Convert.ToInt32(repeatDays[0]);
                int startFrom = Convert.ToInt32(repeatDays[1]);
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    int month = monthDate.StartTime.Month;
                    DateTime weekday = monthDate.StartTime;
                    weekday = weekday.AddDays(startFrom - 1);
                    while (weekday.Month == month && weekday <= endDate)
                    {
                        dayModel = new CronDecryptModel();
                        dayModel.StartTime = weekday;
                        weekday = weekday.AddDays(repeatEvery);
                        dayModel.EndTime = weekday.AddSeconds(-1);
                        days.Add(dayModel);
                    }
                }
            }
            else if (weekExpression.Contains(","))
            {
                string[] repeatDays = weekExpression.Split(',');
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    int month = monthDate.StartTime.Month;
                    int year = monthDate.StartTime.Year;
                    DateTime weekday = monthDate.StartTime;
                    foreach (string dayNumber in repeatDays)
                    {
                        try
                        {
                            if (weekday > endDate)
                                break;
                            weekday = new DateTime(year, month, Convert.ToInt32(dayNumber));
                            dayModel = new CronDecryptModel();
                            dayModel.StartTime = weekday;
                            dayModel.EndTime = weekday.AddSeconds(-1);
                            days.Add(dayModel);
                        }
                        catch (Exception ex) { }
                    }
                }
            }
            else if (weekExpression == "L")
            {
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    DateTime weekday = monthDate.StartTime;
                    weekday = weekday.AddMonths(1);
                    weekday = weekday.AddDays(-1);
                    if (weekday > endDate)
                        break;
                    dayModel = new CronDecryptModel();
                    dayModel.StartTime = weekday;
                    dayModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                    days.Add(dayModel);
                }
            }
            else if (weekExpression == "LW")
            {
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    DateTime weekday = monthDate.StartTime;
                    weekday = weekday.AddMonths(1);
                    weekday = weekday.AddDays(-1);
                    if (weekday.DayOfWeek == DayOfWeek.Sunday)
                        weekday = weekday.AddDays(-2);
                    else if (weekday.DayOfWeek == DayOfWeek.Saturday)
                        weekday = weekday.AddDays(-1);

                    if (weekday > endDate)
                        break;
                    dayModel = new CronDecryptModel();
                    dayModel.StartTime = weekday;
                    dayModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                    days.Add(dayModel);
                }
            }
            else if (weekExpression.Contains("L-"))
            {
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    DateTime weekday = monthDate.StartTime;
                    weekday = weekday.AddMonths(1);
                    weekday = weekday.AddDays(-1);
                    string lastDayInMonth = weekExpression.Split('-')[1];
                    weekday = weekday.AddDays(-Convert.ToInt32(lastDayInMonth));

                    if (weekday > endDate)
                        break;
                    dayModel = new CronDecryptModel();
                    dayModel.StartTime = weekday;
                    dayModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                    days.Add(dayModel);
                }
            }
            else if (weekExpression.Contains("W"))
            {
                int endDay = Convert.ToInt32(weekExpression.TrimEnd('W'));
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    DateTime weekday = monthDate.StartTime;
                    if (weekday.DayOfWeek == DayOfWeek.Sunday)
                        weekday = weekday.AddDays(1);
                    else if (weekday.DayOfWeek == DayOfWeek.Saturday)
                        weekday = weekday.AddDays(2);
                    while (weekday.Day <= endDay)
                    {
                        if (weekday > endDate)
                            break;
                        dayModel = new CronDecryptModel();
                        dayModel.StartTime = weekday;
                        weekday = weekday.AddDays(1);
                        dayModel.EndTime = weekday.AddSeconds(-1);
                        days.Add(dayModel);
                    }
                }
            }
            else if (Int32.TryParse(weekExpression, out day))
            {
                foreach (CronDecryptModel monthDate in weekDates)
                {
                    DateTime weekday = monthDate.StartTime;
                    weekday = weekday.AddMonths(1);
                    weekday = weekday.AddDays(-1);
                    if (weekday > endDate)
                        break;
                    dayModel = new CronDecryptModel();
                    dayModel.StartTime = weekday;
                    dayModel.EndTime = weekday.AddDays(1).AddSeconds(-1);
                    days.Add(dayModel);
                }
            }
            return days;
        }

        public List<CronDecryptModel> getHourWiseDates(string hourExpression, DateTime startDate, DateTime endDate, List<CronDecryptModel> dayWiseDates)
        {
            List<CronDecryptModel> hourlyDays = new List<CronDecryptModel>();
            CronDecryptModel hourModel;
            int hourVal;
            if (hourExpression == "*")
            {
                foreach (CronDecryptModel day in dayWiseDates)
                {
                    DateTime weekday = day.StartTime;
                    for (int hour = 1; hour <= 24; hour++)
                    {
                        if (weekday > endDate)
                            break;
                        hourModel = new CronDecryptModel();
                        hourModel.StartTime = weekday;
                        weekday = weekday.AddHours(hour);
                        hourModel.EndTime = weekday.AddSeconds(-1);
                        hourlyDays.Add(hourModel);
                    }
                }
            }
            else if (hourExpression.Contains("/"))
            {
                string[] repeatHours = hourExpression.Split('/');

                int startHour = Convert.ToInt32(repeatHours[0]);
                int repeater = Convert.ToInt32(repeatHours[1]);
                foreach (CronDecryptModel day in dayWiseDates)
                {
                    DateTime weekday = day.StartTime.AddHours(startHour);

                    while (weekday.Day == day.StartTime.Day)
                    {
                        if (weekday > endDate)
                            break;
                        hourModel = new CronDecryptModel();
                        hourModel.StartTime = weekday;
                        weekday = weekday.AddHours(repeater);
                        hourModel.EndTime = weekday.AddSeconds(-1);
                        hourlyDays.Add(hourModel);
                    }
                }
            }
            else if (hourExpression.Contains(","))
            {
                string[] validHours = hourExpression.Split(',');

                foreach (CronDecryptModel day in dayWiseDates)
                {
                    foreach (var hour in validHours)
                    {
                        DateTime weekday = day.StartTime.AddHours(Convert.ToInt32(hour));

                        if (weekday > endDate)
                            break;
                        hourModel = new CronDecryptModel();
                        hourModel.StartTime = weekday;
                        hourModel.EndTime = weekday.AddHours(1).AddSeconds(-1);
                        hourlyDays.Add(hourModel);
                    }
                }
            }
            else if (hourExpression.Contains("-"))
            {
                string[] validHours = hourExpression.Split('-');
                int startHour = Convert.ToInt32(validHours[0]);
                int endHour = Convert.ToInt32(validHours[1]);

                foreach (CronDecryptModel day in dayWiseDates)
                {
                    bool isValidHour = false;
                    for (int hour = 1; hour <= 24; hour++)
                    {
                        if (hour == startHour)
                        {
                            isValidHour = true;
                        }
                        if (isValidHour)
                        {
                            DateTime weekday = day.StartTime.AddHours(Convert.ToInt32(hour));

                            if (weekday > endDate)
                                break;
                            hourModel = new CronDecryptModel();
                            hourModel.StartTime = weekday;
                            hourModel.EndTime = weekday.AddHours(1).AddSeconds(-1);
                            hourlyDays.Add(hourModel);
                        }
                        if (hour == endHour)
                        {
                            isValidHour = false;
                        }
                    }
                }
            }
            else if (Int32.TryParse(hourExpression, out hourVal))
            {
                foreach (CronDecryptModel day in dayWiseDates)
                {
                    DateTime weekday = day.StartTime;

                    if (weekday > endDate)
                        break;
                    TimeSpan ts = new TimeSpan(hourVal, 0, 0);
                    weekday = weekday + ts;
                    hourModel = new CronDecryptModel();
                    hourModel.StartTime = weekday;
                    hourModel.EndTime = day.EndTime;
                    hourlyDays.Add(hourModel);
                }
            }
            return hourlyDays;
        }

        public List<CronDecryptModel> getMinuteWiseDates(string minuteExpression, DateTime startDate, DateTime endDate, List<CronDecryptModel> hourDates)
        {
            List<CronDecryptModel> minuteDays = new List<CronDecryptModel>();
            CronDecryptModel minuteModel;
            int minutesValue;
            if (minuteExpression == "*")
            {
                foreach (CronDecryptModel day in hourDates)
                {
                    DateTime weekday = day.StartTime;
                    for (int minute = 1; minute <= 60; minute++)
                    {
                        minuteModel = new CronDecryptModel();
                        minuteModel.StartTime = weekday;
                        weekday = weekday.AddMinutes(minute);
                        minuteModel.EndTime = weekday.AddSeconds(-1);
                        minuteDays.Add(minuteModel);
                    }
                }
            }
            else if (minuteExpression.Contains("/"))
            {
                string[] repeatMinute = minuteExpression.Split('/');

                int startMinute = Convert.ToInt32(repeatMinute[0]);
                int repeater = Convert.ToInt32(repeatMinute[1]);
                foreach (CronDecryptModel day in hourDates)
                {
                    DateTime weekday = day.StartTime.AddMinutes(startMinute);
                    while (weekday.Hour == day.StartTime.Hour)
                    {
                        minuteModel = new CronDecryptModel();
                        minuteModel.StartTime = weekday;
                        weekday = weekday.AddMinutes(repeater);
                        minuteModel.EndTime = weekday.AddSeconds(-1);
                        minuteDays.Add(minuteModel);
                    }
                }
            }
            else if (minuteExpression.Contains(","))
            {
                string[] validHours = minuteExpression.Split(',');

                foreach (CronDecryptModel day in hourDates)
                {
                    foreach (var hour in validHours)
                    {
                        DateTime weekday = day.StartTime.AddMinutes(Convert.ToInt32(hour));

                        minuteModel = new CronDecryptModel();
                        minuteModel.StartTime = weekday;
                        minuteModel.EndTime = weekday.AddMinutes(1).AddSeconds(-1);
                        minuteDays.Add(minuteModel);
                    }
                }
            }
            else if (minuteExpression.Contains("-"))
            {
                string[] validHours = minuteExpression.Split('-');
                int startHour = Convert.ToInt32(validHours[0]);
                int endHour = Convert.ToInt32(validHours[1]);

                foreach (CronDecryptModel day in hourDates)
                {
                    bool isValidHour = false;
                    for (int hour = 1; hour <= 60; hour++)
                    {
                        if (hour == startHour)
                        {
                            isValidHour = true;
                        }
                        if (isValidHour)
                        {
                            DateTime weekday = day.StartTime.AddMinutes(Convert.ToInt32(hour));
                            minuteModel = new CronDecryptModel();
                            minuteModel.StartTime = weekday;
                            minuteModel.EndTime = weekday.AddMinutes(1).AddSeconds(-1);
                            minuteDays.Add(minuteModel);
                        }
                        if (hour == endHour)
                        {
                            isValidHour = false;
                        }
                    }
                }
            }
            else if (Int32.TryParse(minuteExpression, out minutesValue))
            {
                foreach (CronDecryptModel day in hourDates)
                {
                    DateTime weekday = day.StartTime;
                    weekday = weekday.AddMinutes(minutesValue);
                    minuteModel = new CronDecryptModel();
                    minuteModel.StartTime = weekday;
                    minuteModel.EndTime = day.EndTime;
                    minuteDays.Add(minuteModel);
                }
            }
            return minuteDays;
        }

        public List<CronDecryptModel> getSecondWiseDates(string secondExpression, DateTime startDate, DateTime endDate, List<CronDecryptModel> minuteDates)
        {
            List<CronDecryptModel> secondsToDays = new List<CronDecryptModel>();
            CronDecryptModel secondModel;
            int secondsValue;

            if (secondExpression == "*")
            {
                foreach (CronDecryptModel day in minuteDates)
                {
                    DateTime weekday = day.StartTime;
                    for (int second = 1; second <= 60; second++)
                    {
                        secondModel = new CronDecryptModel();
                        secondModel.StartTime = weekday;
                        secondModel.EndTime = weekday;
                        secondsToDays.Add(secondModel);
                        weekday = weekday.AddSeconds(second);
                    }
                }
            }
            else if (secondExpression.Contains("/"))
            {
                string[] repeatSecond = secondExpression.Split('/');

                int startSecond = Convert.ToInt32(repeatSecond[0]);
                int repeater = Convert.ToInt32(repeatSecond[1]);
                foreach (CronDecryptModel day in minuteDates)
                {
                    DateTime weekday = day.StartTime.AddSeconds(startSecond);
                    while (weekday.Hour == day.StartTime.Hour)
                    {
                        secondModel = new CronDecryptModel();
                        secondModel.StartTime = weekday;
                        weekday = weekday.AddSeconds(repeater);
                        secondModel.EndTime = weekday.AddSeconds(-1);
                        secondsToDays.Add(secondModel);
                    }
                }
            }
            else if (secondExpression.Contains(","))
            {
                string[] validSeconds = secondExpression.Split(',');

                foreach (CronDecryptModel day in minuteDates)
                {
                    foreach (var second in validSeconds)
                    {
                        DateTime weekday = day.StartTime.AddSeconds(Convert.ToInt32(second));
                        secondModel = new CronDecryptModel();
                        secondModel.StartTime = weekday;
                        secondModel.EndTime = weekday;
                        secondsToDays.Add(secondModel);
                    }
                }
            }
            else if (secondExpression.Contains("-"))
            {
                string[] validSeconds = secondExpression.Split('-');
                int startSecond = Convert.ToInt32(validSeconds[0]);
                int endSecond = Convert.ToInt32(validSeconds[1]);

                foreach (CronDecryptModel day in minuteDates)
                {
                    bool isValidSecond = false;
                    for (int second = 1; second <= 60; second++)
                    {
                        if (second == startSecond)
                        {
                            isValidSecond = true;
                        }
                        if (isValidSecond)
                        {
                            DateTime weekday = day.StartTime.AddSeconds(Convert.ToInt32(second));
                            secondModel = new CronDecryptModel();
                            secondModel.StartTime = weekday;
                            secondModel.EndTime = weekday;
                            secondsToDays.Add(secondModel);
                        }
                        if (second == endSecond)
                        {
                            isValidSecond = false;
                        }
                    }
                }
            }
            else if (Int32.TryParse(secondExpression, out secondsValue))
            {
                foreach (CronDecryptModel day in minuteDates)
                {
                    DateTime weekday = day.StartTime;
                    weekday = weekday.AddSeconds(secondsValue);
                    secondModel = new CronDecryptModel();
                    secondModel.StartTime = weekday;
                    secondModel.EndTime = day.EndTime;
                    secondsToDays.Add(secondModel);
                }
            }
            return secondsToDays;
        }
    }
}
