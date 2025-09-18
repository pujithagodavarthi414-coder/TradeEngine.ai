using System;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerAppReportUsageSearchOutputModel
    {
        public Guid? ApplicationId { get; set; }
        public string AppUrlImage { get; set; }
        public string ApplicationName { get; set; }
        public Guid? ApplicationTypeId { get; set; }
        public string ApplicationTypeName { get; set; }
        public double SpentValue { get; set; }
        public int TotalCount { get; set; }
    }
}
