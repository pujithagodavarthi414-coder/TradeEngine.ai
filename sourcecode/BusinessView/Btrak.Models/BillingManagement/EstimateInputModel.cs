using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class EstimateInputModel : SearchCriteriaInputModelBase
    {
        public EstimateInputModel() : base(InputTypeGuidConstants.EstimateInputCommandTypeGuid)
        {
        }

        public Guid? EstimateId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EstimateId" + EstimateId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("BranchId" + BranchId);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("SearchText" + SearchText);
            return base.ToString();
        }
    }
}
