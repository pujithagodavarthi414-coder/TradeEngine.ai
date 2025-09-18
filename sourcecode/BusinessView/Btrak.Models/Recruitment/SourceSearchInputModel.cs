using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class SourceSearchInputModel : SearchCriteriaInputModelBase
    {
        public SourceSearchInputModel() : base(InputTypeGuidConstants.SourceSearchInputCommandTypeGuid)
        {
        }

        public Guid? SourceId { get; set; }
        public string Name { get; set; }
        public bool IsReferenceNumberNeeded { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + SourceId);
            stringBuilder.Append(",Name = " + Name);
            stringBuilder.Append(",IsReferenceNumberNeeded = " + IsReferenceNumberNeeded);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
