using System;
using System.Text;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportingConfigurationFormApiReturnModel
    {
        public Guid GenericFormId { get; set; }
        public Guid StatusReportingConfigurationOptionId { get; set; }
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public Guid AssignedBy { get; set; }
        public bool IsSubmitted { get; set; }
        public Guid StatusReportingConfigurationId { get; set; }
        public string ReportingDays { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public string ProjectStatusColor { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string FullName { get; set; }
        public Guid? CompanyId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public Guid? RoleId { get; set; }
        public bool? IsPasswordForceReset { get; set; }
        public bool? IsActive { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool? IsAdmin { get; set; }
        public bool? IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public string RoleName { get; set; }
        public string ProjectTypeName { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GenericFormId = " + GenericFormId);
            stringBuilder.Append(", StatusReportingConfigurationOptionId = " + StatusReportingConfigurationOptionId);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", AssignedBy = " + AssignedBy);
            stringBuilder.Append(", IsSubmitted = " + IsSubmitted);
            stringBuilder.Append(", StatusReportingConfigurationId = " + StatusReportingConfigurationId);
            stringBuilder.Append(", ReportingDays = " + ReportingDays);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", ProjectStatusColor = " + ProjectStatusColor);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", IsPasswordForceReset = " + IsPasswordForceReset);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", IsAdmin = " + IsAdmin);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", RegisteredDateTime = " + RegisteredDateTime);
            stringBuilder.Append(", LastConnection = " + LastConnection);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", ProjectTypeName = " + ProjectTypeName);
            stringBuilder.Append(", ProjectTypeId = " + ProjectTypeId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
