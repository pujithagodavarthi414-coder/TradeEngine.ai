using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GetTrendsInputModel : InputModelBase
    {
        public GetTrendsInputModel() : base(InputTypeGuidConstants.GenericFormSubmittedUpsertInputModel)
        {
        }

        public Guid? TrendId { get; set; }
        public int? UniqueNumber { get; set; }
        public string SearchTrendValue { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", TrendId = " + TrendId);
            stringBuilder.Append(", UniqueNumber = " + UniqueNumber);
            stringBuilder.Append(", SearchTrendValue = " + SearchTrendValue);
            return stringBuilder.ToString();
        }
    }
}
