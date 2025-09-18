using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class TemplateSearchInputmodel : SearchCriteriaInputModelBase
    {
        public TemplateSearchInputmodel() : base(InputTypeGuidConstants.TemplateSearchInputmodelInputCommandTypeGuid)
        {
        }

        public Guid? TemplateId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TemplateId = " + TemplateId);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            return stringBuilder.ToString();
        }
    }
}
