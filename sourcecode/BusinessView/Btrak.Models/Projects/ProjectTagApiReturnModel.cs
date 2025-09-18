using System;
using System.Text;

namespace Btrak.Models.Projects
{
    public class ProjectTagApiReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string Tag { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", TagName = " + Tag);
            return stringBuilder.ToString();
        }
    }
}
