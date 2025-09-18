using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.DocumentManagement
{
    public class StoreSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public StoreSearchCriteriaInputModel() : base(InputTypeGuidConstants.StoreSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? StoreId { get; set; }
        public string StoreName { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsCompany { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StoreId = " + StoreId);
            stringBuilder.Append("StoreName = " + StoreName);
            stringBuilder.Append("IsDefault = " + IsDefault);
            stringBuilder.Append("IsCompany = " + IsCompany);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
