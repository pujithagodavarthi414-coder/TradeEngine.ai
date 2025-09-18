using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ProjectType
{
    public class ProjectTypeUpsertInputModel : InputModelBase
    {
        public ProjectTypeUpsertInputModel() : base(InputTypeGuidConstants.ProjectTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
        public bool IsArchived { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectTypeId = " + ProjectTypeId);
            stringBuilder.Append(", ProjectTypeName = " + ProjectTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
