using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CustomTags
{

    public class CustomTagsSearchCriteriaModel : SearchCriteriaInputModelBase
    {
        public CustomTagsSearchCriteriaModel() : base(InputTypeGuidConstants.CustomTagsSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? ReferenceId { get; set; }
        public string Tag { get; set; }
        public string Tags { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReferenceId = " + ReferenceId);
            stringBuilder.Append("Tag = " + Tag);
            return stringBuilder.ToString();
        }
    }
}
