using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Projects
{
    public class ProjectTagSearchInputModel : InputModelBase
    {
        public ProjectTagSearchInputModel() : base(InputTypeGuidConstants.ProjectTagSearchInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public string SearchText { get; set; }
        public string Tag { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", Tag = " + Tag);
            return stringBuilder.ToString();
        }
    }
}
