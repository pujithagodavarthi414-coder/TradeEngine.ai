using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class StatusReportSpEntity
    {
        public Guid StatusReportingId { get; set; }
        public string Description { get; set; }
        public DateTime StatusReportSubmittedDate { get; set; }
        public bool IsReportSubmitted { get; set; }
        public bool IsReviewed { get; set; }
        public Guid ConfigurationId { get; set; }
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
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public bool AttachmentsSubmitted { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string ProfileImage { get; set; }
        public Guid FileId { get; set; }
        public Guid StatusAttachmentId { get; set; }
    }

    public class SetStatusReportSpEntity
    {
        public Guid StatusReportingConfigurationId { get; set; }
        public Guid StatusReportingOptionId { get; set; }
        public Guid StatusReportingStatusId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
    }

    public class StatusReportToDoSpEntity
    {
        public Guid StatusSetToUserId { get; set; }
        public string Name { get; set; }
        public Guid ReportId { get; set; }
        public string DisplayName { get; set; }
        public string ProfileImage { get; set; }
        public int TotalNotReviewedReports { get; set; }
        public int TotalNotSubmittedReports { get; set; }
        public string ShowPopup { get; set; }
    }
}
