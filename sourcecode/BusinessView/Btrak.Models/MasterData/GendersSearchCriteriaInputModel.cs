using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GendersSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GendersSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetGenders)
        {
        }
        public Guid? GenderId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GenderId = " + GenderId);
            return stringBuilder.ToString();
        }
    }
}
