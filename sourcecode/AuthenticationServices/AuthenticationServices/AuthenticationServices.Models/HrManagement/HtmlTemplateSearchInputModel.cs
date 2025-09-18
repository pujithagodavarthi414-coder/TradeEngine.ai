using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.HrManagement
{
    public class HtmlTemplateSearchInputModel : InputModelBase
    {
        public HtmlTemplateSearchInputModel() : base(InputTypeGuidConstants.HtmlTemplateSearchInputCommandTypeGuid)
        {
        }

        public Guid? HtmlTemplateId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HtmlTemplateId = " + HtmlTemplateId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchive = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
