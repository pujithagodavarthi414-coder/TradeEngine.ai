using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.SoftLabels
{
    public class SoftLabelsInputMethod : InputModelBase
    {
        public SoftLabelsInputMethod() : base(InputTypeGuidConstants.SoftLabelsInputCommandTypeGuid)
        {
        }
        public Guid? SoftLabelId { get; set; }
        public string SoftLabelName { get; set; }
        public string SoftLabelKeyType { get; set; }
        public string SoftLabelValue { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" SoftLabelId = " + SoftLabelId);
            stringBuilder.Append(", SoftLabelName = " + SoftLabelName);
            stringBuilder.Append(", SoftLabelKeyType = " + SoftLabelKeyType);
            stringBuilder.Append(", SoftLabelValue = " + SoftLabelValue);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
