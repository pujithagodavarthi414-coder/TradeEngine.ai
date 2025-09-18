using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetStatesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetStatesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetStates)
        {
        }
        public Guid? StateId { get; set; }
      
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" StateId = " + StateId);
            return stringBuilder.ToString();
        }
    }
}
