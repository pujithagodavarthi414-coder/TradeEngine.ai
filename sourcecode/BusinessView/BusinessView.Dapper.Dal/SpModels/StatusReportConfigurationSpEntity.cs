using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class StatusReportConfigurationSpEntity
    {
        public Guid Id { get; set; }
        public string ReportText { get; set; }
        public Guid StatusSetByUserId { get; set; }
        public string SetByUser { get; set; }
        public Guid StatusSetToUserId { get; set; }
        public string SetToUser { get; set; }
        public Guid StatusReportingStatusId { get; set; }
        public string Status { get; set; }
        public Guid StatusReportingOptionId { get; set; }
        public string Option { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
    }
}
