using System;

namespace Btrak.Models.ActivityTracker
{
    public class GetTimeUsageDrillDownOutputModel
    {
        public Guid UserId { get; set; }
        public string Name { get; set; }
        public string AppUrlImage { get; set; }
        public string ApplicationName { get; set; }
        public string ApplicationTypeName { get; set; }
        public double SpentValue { get; set; }
        public int TotalCount { get; set; }
    }
}
