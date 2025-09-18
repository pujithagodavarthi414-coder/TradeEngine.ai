using System;

namespace Btrak.Services.Helpers
{
    public class CommonHelper
    {
        public static string GetElapsedTime(DateTime? startTime, DateTime? endTime = null)
        {
            startTime = startTime ?? DateTime.Now;
            endTime = endTime ?? DateTime.Now;

            var executionTime = endTime.Value - startTime.Value;

            var executionTimeStr = executionTime.TotalDays > 1 ?
                "" + new DateTime(executionTime.Ticks).ToString("%d \'days\' HH:mm \'Hours\'") :
                executionTime.TotalHours > 1 ?
                "" + new DateTime(executionTime.Ticks).ToString("HH:mm:ss") + " Hours." :
                (executionTime.TotalMinutes > 1 ? "" + new DateTime(executionTime.Ticks).ToString("mm:ss") + " mins." :
                "" + new DateTime(executionTime.Ticks).ToString("ss") + " secs.");

            return executionTimeStr;
        }       
    }
}