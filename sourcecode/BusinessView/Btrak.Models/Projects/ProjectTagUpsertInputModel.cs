using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Projects
{
    public class ProjectTagUpsertInputModel : InputModelBase
    {
        public ProjectTagUpsertInputModel() : base(InputTypeGuidConstants.ProjectTagUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public string Tags { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", Tags = " + Tags);
            return stringBuilder.ToString();
        }
    }
}

