using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class ProjectFeatureUpsertInputModel : InputModelBase
    {
        public ProjectFeatureUpsertInputModel() : base(InputTypeGuidConstants.ProjectFeatureUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public string TimeZone { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? ProjectFeatureResponsiblePersonId { get; set; }
        public bool IsDelete { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", ProjectFeatureName = " + ProjectFeatureName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectFeatureResponsiblePersonId = " + ProjectFeatureResponsiblePersonId);
            stringBuilder.Append(", IsDelete = " + IsDelete);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}
