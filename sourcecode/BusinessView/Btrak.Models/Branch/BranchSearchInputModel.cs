using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Branch
{
    public class BranchSearchInputModel : InputModelBase
    {
        public BranchSearchInputModel() : base(InputTypeGuidConstants.BranchSearchInputCommandTypeGuid)
        {
        }

        public Guid? BranchId { get; set; }
        public string SearchText { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BranchId = " + BranchId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
