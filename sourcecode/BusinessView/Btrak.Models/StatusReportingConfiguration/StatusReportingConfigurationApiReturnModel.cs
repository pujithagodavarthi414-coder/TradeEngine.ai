using System;
using System.Text;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportingConfigurationApiReturnModel
    {
        public Guid Id { get; set; }
        public Guid? OriginalId { get; set; }
        public string ConfigurationName { get; set; }
        public Guid FormTypeId { get; set; }
        public string FormType { get; set; }
        public string FormName { get; set; }
        public Guid GenericFormId { get; set; }
        public string EmployeeIds { get; set; }
        public string AssignedToEmployees { get; set; }
        public string StatusReportingOptionIds { get; set; }
        public string StatusConfigurationOptions { get; set; }
        public string ReportingDays { get; set; }
        public Guid AssignedByUserId { get; set; }
        public string AssignedByUserName { get; set; }
        public DateTime AssignedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid ArchivedByUserId { get; set; }
        public DateTime ArchivedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsArchived { get; set; }
        public int? TotalCount { get; set; }
        public Guid? AssignedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ConfigurationName = " + ConfigurationName);
            stringBuilder.Append(", FormTypeId = " + FormTypeId);
            stringBuilder.Append(", FormType = " + FormType);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", GenericFormId = " + GenericFormId);
            stringBuilder.Append(", EmployeeIds = " + EmployeeIds);
            stringBuilder.Append(", AssignedToEmployees = " + AssignedToEmployees);
            stringBuilder.Append(", StatusReportingOptionIds = " + StatusReportingOptionIds);
            stringBuilder.Append(", StatusConfigurationOptions = " + StatusConfigurationOptions);
            stringBuilder.Append(", ReportingDays = " + ReportingDays);
            stringBuilder.Append(", AssignedByUserId = " + AssignedByUserId);
            stringBuilder.Append(", AssignedByUserName = " + AssignedByUserName);
            stringBuilder.Append(", AssignedDateTime = " + AssignedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", ArchivedByUserId = " + ArchivedByUserId);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", AssignedBy = " + AssignedBy);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}