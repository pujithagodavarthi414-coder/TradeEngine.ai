using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class ProjectFeatureSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ProjectFeatureSearchCriteriaInputModel() : base(InputTypeGuidConstants.ProjectFeatureSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? IsDelete { get; set; }
        public Guid? ProjectFeatureResponsiblePersonId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", ProjectFeatureName = " + ProjectFeatureName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectFeatureResponsiblePersonId = " + ProjectFeatureResponsiblePersonId);
            stringBuilder.Append(", IsDelete = " + IsDelete);
            return stringBuilder.ToString();
        }
    }
}
