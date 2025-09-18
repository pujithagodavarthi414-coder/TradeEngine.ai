using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Assets
{
    public class AssetCommentAndHistorySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public AssetCommentAndHistorySearchCriteriaInputModel() : base(InputTypeGuidConstants.AssetCommentAndHistorySearchCriteriaInputModel)
        {
        }


        public Guid? AssetId { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", AssetId = " + AssetId);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            stringBuilder.Append(", PageSize = " + PageSize);
            return stringBuilder.ToString();
        }
    }
}
