using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportingConfigurationSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public StatusReportingConfigurationSearchCriteriaInputModel() : base(InputTypeGuidConstants.StatusReportingConfigurationSearchCriteriaInputCommandTypeGuid)
        {
        }

        public string ConfigurationName { get; set; }
        public Guid AssignedByUserId { get; set; }
        public Guid? StatusReportingConfigurationId { get; set; }
        public Guid? GenericFormId { get; set; }
        public Guid? FormTypeId { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConfigurationName = " + ConfigurationName);
            stringBuilder.Append(", AssignedByUserId = " + AssignedByUserId);
            stringBuilder.Append(", StatusReportingConfigurationId = " + StatusReportingConfigurationId);
            stringBuilder.Append(", GenericFormId = " + GenericFormId);
            stringBuilder.Append(", FormTypeId = " + FormTypeId);
            return stringBuilder.ToString();
        }
    }
}