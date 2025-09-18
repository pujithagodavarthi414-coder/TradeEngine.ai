using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ProjectType
{
    public class ProjectTypeInputModel : InputModelBase
    {
        public ProjectTypeInputModel() : base(InputTypeGuidConstants.ProjectTypeInputCommandTypeGuid)
        {
        }

        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
        public bool? IsArchived { get; set; }

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
