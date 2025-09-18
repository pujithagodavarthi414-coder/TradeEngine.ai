using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class ProjectSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ProjectSearchCriteriaInputModel() : base(InputTypeGuidConstants.ProjectSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public string ProjectIds { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public string ProjectStatusColor { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public string ProjectIdsXml { get; set; }
        public string ProjectSearchFilter { get; set; }

    public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", ProjectTypeId = " + ProjectTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ProjectStatusColor = " + ProjectStatusColor);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", ProjectSearchFilter = " + ProjectSearchFilter);
            return stringBuilder.ToString();
        }
    }
}
