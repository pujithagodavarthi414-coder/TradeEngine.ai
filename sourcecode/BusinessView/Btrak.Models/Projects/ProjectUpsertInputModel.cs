using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class ProjectUpsertInputModel : InputModelBase
    {
        public ProjectUpsertInputModel() : base(InputTypeGuidConstants.ProjectUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TimeZone { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public bool IsArchived { get; set; }
        public bool IsDateTimeConfiguration { get; set; }
        public bool IsSprintsConfiguration { get; set; }
        public string ProjectStatusColor { get; set; }
        public DateTimeOffset? ProjectStartDate { get; set; }
        public DateTimeOffset? ProjectEndDate { get; set; }
        public int TimeZoneOffset { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", ProjectTypeId = " + ProjectTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsDateTimeConfiguration = " + IsDateTimeConfiguration);
            stringBuilder.Append(", IsSprintsConfiguration = " + IsSprintsConfiguration);
            stringBuilder.Append(", ProjectStatusColor = " + ProjectStatusColor);
            return stringBuilder.ToString();
        }
    }
}
