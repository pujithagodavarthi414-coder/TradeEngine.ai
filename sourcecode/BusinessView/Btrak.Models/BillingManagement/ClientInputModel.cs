using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ClientInputModel : SearchCriteriaInputModelBase
    {
        public ClientInputModel() : base(InputTypeGuidConstants.ClientInputCommandTypeGuid)
        {
        }

        public Guid? ClientId { get; set; }
        public Guid? ClientAddressId { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? EntityId { get; set; }
        public Guid? ClientType { get; set; }
        public string ClientTypeName { get; set; }
        public string ReferenceType { get; set; }
        public Guid? UserId { get; set; }

        public bool? IsForMail { get; set; }
        public bool? IsForAPI { get; set; }

        //public bool? IsArchived { get; set; }
        //public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("ClientAddressId" + ClientAddressId);
            stringBuilder.Append("ProjectTypeId" + ProjectTypeId);
            stringBuilder.Append("BranchId" + BranchId);
            stringBuilder.Append("EntityId" + EntityId);
            stringBuilder.Append("IsForMail" + IsForMail);
            // stringBuilder.Append("IsArchived" + IsArchived);
            //stringBuilder.Append("SearchText" + SearchText);
            return base.ToString();
        }

    }
}