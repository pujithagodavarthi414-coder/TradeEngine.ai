using System;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class SpentTimeReportSearchInputModel : SearchCriteriaInputModelBase
    {
        public SpentTimeReportSearchInputModel() : base(InputTypeGuidConstants.SpentTimeReportInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public string DateDescription { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public int Days { get; set; }
        public string UserDescription { get; set; }
        public Guid? UserId { get; set; }
        public string HoursDescription { get; set; }
        public int? HoursFrom { get; set; }
        public int? HoursTo { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public string UserStoryTypeDescription { get; set; }
    }
}
