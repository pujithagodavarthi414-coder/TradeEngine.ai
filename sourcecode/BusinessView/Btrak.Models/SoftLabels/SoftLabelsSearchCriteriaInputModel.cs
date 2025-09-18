using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.SoftLabels
{
    public class SoftLabelsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SoftLabelsSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchSoftLabel)
        {
        }
        public Guid? SoftLabelId { get; set; }
        public string SoftLabelName { get; set; }
      
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" SoftLabelId = " + SoftLabelId);
            stringBuilder.Append(", SoftLabelName = " + SoftLabelName);
            return stringBuilder.ToString();
        }
    }
}
