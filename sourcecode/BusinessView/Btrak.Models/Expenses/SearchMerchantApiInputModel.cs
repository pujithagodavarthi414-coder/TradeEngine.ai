using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class SearchMerchantApiInputModel : SearchCriteriaInputModelBase
    {
        public SearchMerchantApiInputModel() : base(InputTypeGuidConstants.SearchMerchantInputCommandTypeGuid)
        {
        }

        public Guid? MerchantId { get; set; }
        public string MerchantName { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MerchantId = " + MerchantId);
            stringBuilder.Append(", MerchantNameSearchText = " + MerchantName);
            stringBuilder.Append(", DescriptionSearchText = " + Description);
            return stringBuilder.ToString();
        }
    }
}
